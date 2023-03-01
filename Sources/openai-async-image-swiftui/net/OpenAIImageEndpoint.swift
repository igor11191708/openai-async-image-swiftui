//
//  OpenAIImageEndpoint.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Set of specs for access to OpenAPI image resource
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct OpenAIImageEndpoint: IOpenAIImageEndpoint{
        
    // MARK: - Static
    
    /// Base url to OpenAPI image resource
    public static var urlString = "https://api.openai.com"
    
    /// Path to the point
    public static var path = "/v1/images/generations"
    
    /// - Parameter apiKey: Api key for access
    /// - Returns: Endpoint
    static public func get(with apiKey: String) -> Self{
        .init(
            urlString: Self.urlString,
            apiKey: apiKey,
            path: Self.path)
    }
    
    // MARK: - Config
    
    /// Base url to OpenAPI image resource
    public let urlString: String
    
    /// Path to the point
    public let path : String
    
    /// Api key for access
    public let apiKey : String

    // MARK: - Life circle
    
    /// - Parameters:
    ///   - urlString: Base url to OpenAPI image resource
    ///   - httpMethod: Http method
    ///   - apiKey: Api key for access
    ///   - path: Path to the point
    public init(urlString: String, apiKey: String, path: String) {
        self.urlString = urlString
        self.apiKey = apiKey
        self.path = path
    }
}
