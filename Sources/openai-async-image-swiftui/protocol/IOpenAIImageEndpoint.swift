//
//  File.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import Foundation

/// Defines access API to OpenAI image API
public protocol IOpenAIImageEndpoint{
    
    /// Base url to OpenAPI image resource
    var urlString : String { get }
    
    /// Http method
    var httpMethod : String { get }
    
    /// Api key for access
    var apiKey : String { get }
    
}
