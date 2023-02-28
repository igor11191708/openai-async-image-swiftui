//
//  OpenAIImageEndpoint.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Set of specs for acces to OpenAPI image resource
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct OpenAIImageEndpoint: IOpenAIImageEndpoint{
        
    // MARK: - Static
    
    /// Base url to OpenAPI image resource
    public static var urlString = "https://api.openai.com"
    
    /// Http method
    public static var httpMethod = "POST"
    
    /// - Parameter apiKey: Api key for access
    /// - Returns: Endpoint
    static public func get(with apiKey: String) -> Self{
        .init(urlString: Self.urlString, httpMethod: Self.httpMethod, apiKey: apiKey)
    }
    
    // MARK: - Config
    
    
    /// Base url to OpenAPI image resource
    public let urlString: String
    
    /// Http method
    public let httpMethod : String
    
    /// Api key for access
    public let apiKey : String

    // MARK: - Life circle
    
    /// - Parameters:
    ///   - urlString: Base url to OpenAPI image resource
    ///   - httpMethod: Http method
    ///   - apiKey: Api key for access
    public init(urlString: String, httpMethod: String, apiKey: String) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.apiKey = apiKey
    }
    
    

}
