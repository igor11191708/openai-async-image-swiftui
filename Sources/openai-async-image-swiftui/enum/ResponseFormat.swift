//
//  ResponseFormat.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Type of response format from OpenAI API
@available(iOS 15.0, macOS 12.0, *)
enum ResponseFormat: String,Encodable{
    
    case url = "url"
    
    case b64 = "b64_json"
}
