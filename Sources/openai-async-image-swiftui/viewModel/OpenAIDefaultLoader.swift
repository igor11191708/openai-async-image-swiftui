//
//  OpenAIViewModel.swift
//
//
//  Created by Igor on 28.02.2023.
//

import SwiftUI
import async_http_client

#if os(iOS)
import UIKit.UIImage
#endif

#if os(macOS)
import AppKit.NSImage
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public final class OpenAIDefaultLoader: IOpenAILoader, Sendable {
    
    /// HTTP async client to handle requests
    private let client: Http.Proxy<JsonReader, JsonWriter>?
    
    /// Endpoint parameters required for making requests
    private let endpoint: IOpenAIImageEndpoint
    
    /// Initializes the loader with endpoint parameters
    /// - Parameter endpoint: Set of parameters for making requests
    public init(endpoint: IOpenAIImageEndpoint) {
        self.endpoint = endpoint
        
        guard let url = URL(string: endpoint.urlString) else {
            client = nil
            return
        }
        
        client = Http.Proxy(baseURL: url)
    }
       
    /// Asynchronously loads an image from the OpenAI API using a text prompt and specified parameters.
    /// - Parameters:
    ///   - prompt: The text prompt describing the desired image content.
    ///   - size: The dimensions of the generated image, specified as `OpenAIImageSize`.
    ///   - model: The `DalleModel` used for generating the image.
    /// - Returns: A generated `Image` object based on the prompt and size.
    /// - Throws: An `AsyncImageErrors` if the client is undefined, the request fails,
    ///           or the OpenAI API returns an error.
    public func load(
        _ prompt: String,
        with size: OpenAIImageSize,
        model: DalleModel
    ) async throws -> Image {
        
        guard let client = client else {
            throw AsyncImageErrors.clientIsNotDefined
        }
        
        do {
            let (path, body, headers) = prepareRequest(prompt: prompt, size: size, model: model)
            let result: Http.Response<Output> = try await client.post(path: path, body: body, headers: headers)
            return try imageBase64(from: result.value)
            
        } catch {
            throw AsyncImageErrors.handleRequest(error)
        }
    }

    /// Prepares the API request for generating an image with the given parameters.
    /// - Parameters:
    ///   - prompt: The descriptive text prompt for generating the image.
    ///   - size: The dimensions of the image to be generated, as `OpenAIImageSize`.
    ///   - model: The `DalleModel` specifying the AI model to use for generation.
    /// - Returns: A tuple containing:
    ///   - `path`: The API endpoint path as a `String`.
    ///   - `body`: The request payload as an `Input` object, containing model, prompt, size, and other parameters.
    ///   - `headers`: A dictionary of HTTP headers required for the request.
    private func prepareRequest(prompt: String, size: OpenAIImageSize, model: DalleModel) -> (String, Input, [String: String]) {
        let body = Input(model: model.rawValue, prompt: prompt, size: size, response_format: .b64, n: 1)
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(endpoint.apiKey)"]
        let path = endpoint.path
        return (path, body, headers)
    }
    
        
    /// Decodes base64 encoded string to Data
    /// - Parameter output: The output received from the endpoint
    /// - Returns: Decoded Data
    private func decodeBase64(from output: Output) throws -> Data? {
        guard let base64 = output.firstImage else {
            throw AsyncImageErrors.returnedNoImages
        }
        
        return Data(base64Encoded: base64)
    }
       
#if os(macOS)
    /// Converts base64 encoded string to NSImage for macOS
    /// - Parameter output: OpenAI response type
    /// - Returns: NSImage
    private func imageBase64(from output: Output) throws -> Image {
        let data = try decodeBase64(from: output)
        
        if let data, let image = NSImage(data: data) {
            return Image(nsImage: image)
        }
        
        throw AsyncImageErrors.imageInit
    }
#else
    /// Converts base64 encoded string to UIImage for iOS
    /// - Parameter output: OpenAI response type
    /// - Returns: UIImage
    private func imageBase64(from output: Output) throws -> Image {
        let data = try decodeBase64(from: output)
        
        if let data, let image = UIImage(data: data) {
            return Image(uiImage: image)
        }
        
        throw AsyncImageErrors.imageInit
    }
#endif
    
}
