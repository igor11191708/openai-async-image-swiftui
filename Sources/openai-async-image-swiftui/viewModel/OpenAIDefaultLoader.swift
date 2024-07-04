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
public final class OpenAIDefaultLoader : IOpenAILoader{
    
    /// HTTP async client to handle requests
    private let client : Http.Proxy<JsonReader, JsonWriter>?
    
    /// Endpoint parameters required for making requests
    private let endpoint : IOpenAIImageEndpoint
    
    /// Initializes the loader with endpoint parameters
    /// - Parameter endpoint: Set of parameters for making requests
    public init(endpoint : IOpenAIImageEndpoint) {
        
        self.endpoint = endpoint
        
        guard let url = URL(string: endpoint.urlString) else{
            client = nil
            return
        }
        
        client = Http.Proxy(baseURL: url)
    }
       
    /// Loads an image from the OpenAI API based on a text prompt
    /// - Parameters:
    ///   - prompt: The text prompt describing the desired image
    ///   - size: The size of the generated image
    /// - Returns: OpenAI Image
    public func load(
        _ prompt : String,
        with size : OpenAIImageSize
    ) async throws -> Image{
        
        // Prepare the request body with the prompt and size
        let body = Input(prompt: prompt, size: size, response_format: .b64, n: 1)
        
        // Set the request headers, including authorization
        let headers = ["Content-Type": "application/json","Authorization": "Bearer \(endpoint.apiKey)"]
        let path = endpoint.path
        
        guard let client = client else{
            throw AsyncImageErrors.clientIsNotDefined
        }
        
        // Send the request and get the response
        let result: Http.Response<Output> = try await client.post(path: path, body: body, headers: headers)
        
        // Convert the response to an image
        return try imageBase64(from: result.value)
    }
        
    /// Decodes base64 encoded string to Data
    /// - Parameter output: The output received from the endpoint
    /// - Returns: Decoded Data
    private func decodeBase64(from output: Output) throws -> Data?{
        guard let base64 = output.firstImage else  {
            throw AsyncImageErrors.returnedNoImages
        }
        
        return Data(base64Encoded: base64)
    }
    
#if os(iOS) || os(watchOS) || os(tvOS)
    /// Converts base64 encoded string to UIImage for iOS
    /// - Parameter output: OpenAI response type
    /// - Returns: UIImage
    private func imageBase64(from output: Output) throws -> Image {
        
        let data = try decodeBase64(from: output)
        
        if let data, let image = UIImage(data: data){
            return Image(uiImage: image)
        }
        
        throw AsyncImageErrors.imageInit
    }
#endif
    
#if os(macOS)
    /// Converts base64 encoded string to NSImage for macOS
    /// - Parameter output: OpenAI response type
    /// - Returns: NSImage
    private func imageBase64(from output: Output) throws -> Image {
        
        let data = try decodeBase64(from: output)
        
        if let data, let image = NSImage(data: data){
            return Image(nsImage: image)
        }
        
        throw AsyncImageErrors.imageInit
    }
#endif
}
