//
//  IOpenAIImageEndpoint.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import Foundation

/// Protocol defining access to the OpenAI image API
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol IOpenAIImageEndpoint {
    
    /// Base URL for the OpenAI image resource
    var urlString: String { get }
    
    /// Path to the specific endpoint within the OpenAI API
    var path: String { get }
    
    /// API key for authentication and access to the OpenAI API
    var apiKey: String { get }

}
