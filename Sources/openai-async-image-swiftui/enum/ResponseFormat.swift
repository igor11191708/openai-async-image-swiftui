//
//  ResponseFormat.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Type of response format from OpenAI API
enum ResponseFormat: String,Encodable{
    
    case url = "url"
    
    case b64 = "b64_json"
}
