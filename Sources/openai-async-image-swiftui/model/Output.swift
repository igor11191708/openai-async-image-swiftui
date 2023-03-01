//
//  Response.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Output format for OpenAI API
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct Output: Decodable{
    
    /// Date and time
    let created : Int
    
    /// Set of images
    let data: [Base64]
        
    /// Fist image from the received data set
    var firstImage : String?{
        data.first?.b64_json
    }
}

struct Base64: Decodable{
    let b64_json : String
}
