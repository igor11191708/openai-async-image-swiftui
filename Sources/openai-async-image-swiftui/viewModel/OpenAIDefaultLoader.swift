//
//  OpenAIViewModel.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import async_http_client

#if os(iOS)
import UIKit.UIImage
#endif

#if os(macOS)
import AppKit.NSImage
#endif

import SwiftUI

public final class OpenAIDefaultLoader : IOpenAILoader{
    
    /// Http async client
    private let client : Http.Proxy<JsonReader, JsonWriter>?
    
    /// Set of params for making requsts
    private let endpoint : IOpenAIImageEndpoint
    
    /// - Parameter endpoint: Set of params for making requsts
    public init(endpoint : IOpenAIImageEndpoint) {
        
        self.endpoint = endpoint
        
        guard let url = URL(string: endpoint.urlString) else{
            client = nil
            return
        }
        
        client = Http.Proxy(baseURL: url)
    }
    
    /// Load image by text
    /// - Parameters:
    ///   - prompt: Text
    ///   - size: Image size
    /// - Returns: Open AI Image
    public func load(
        _ prompt : String,
        with size : OpenAIImageSize
    ) async throws -> Image{
        
        let body = Input(prompt: prompt, size: size, response_format: .b64)
        
        let headers = ["Authorization": "Bearer \(endpoint.apiKey)"]
        let path = "/v1/images/generations"
        
        guard let client = client else{
            throw AsyncImageErrors.clientIsNotDefined
        }
        
        let result: Http.Response<Output> = try await client.post(path: path, body: body, headers: headers)
        
        if let status = result.statusCode, status != 200 {
            throw AsyncImageErrors.status(status)
        }
        
        return try imageBase64(from: result.value)
        
    }
    
    private func decodeBase64(from output: Output) throws -> Data?{
        guard let base64 = output.firstImage else  {
            throw AsyncImageErrors.returnedNoImages
        }
        
        return Data(base64Encoded: base64)
    }
    
#if os(iOS)
    /// Base64 encoder for iOS
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
    /// Base64 encoder for macOS
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
