//
//  OpenAIImageEndpoint.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Struct providing specifications for accessing the OpenAI image resource
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct OpenAIImageEndpoint: IOpenAIImageEndpoint {
        
    // MARK: - Static Properties
    
    /// Static base URL for the OpenAI image resource
    public static var urlString = "https://api.openai.com"
    
    /// Static path to the specific endpoint for generating images
    public static var path = "/v1/images/generations"
    
    /// Creates an instance of `OpenAIImageEndpoint` with the provided API key
    /// - Parameter apiKey: API key for accessing the OpenAI API
    /// - Returns: Configured instance of `OpenAIImageEndpoint`
    public static func get(with apiKey: String) -> Self {
        .init(
            urlString: Self.urlString,
            apiKey: apiKey,
            path: Self.path
        )
    }
    
    // MARK: - Instance Properties
    
    /// Base URL for the OpenAI image resource
    public let urlString: String
    
    /// Path to the specific endpoint
    public let path: String
    
    /// API key for authentication and access to the OpenAI API
    public let apiKey: String

    // MARK: - Initializer
    
    /// Initializes a new instance of `OpenAIImageEndpoint`
    /// - Parameters:
    ///   - urlString: Base URL for the OpenAI image resource
    ///   - apiKey: API key for accessing the OpenAI API
    ///   - path: Path to the specific endpoint
    public init(urlString: String, apiKey: String, path: String) {
        self.urlString = urlString
        self.apiKey = apiKey
        self.path = path
    }
}
