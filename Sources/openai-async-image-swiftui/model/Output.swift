//
//  Response.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Structure representing the output format for the OpenAI API response
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct Output: Decodable {
    
    /// The creation date and time of the response in UNIX timestamp format
    let created: Int
    
    /// An array of base64 encoded images
    let data: [Base64]
        
    /// The first image from the received data set, if available
    var firstImage: String? {
        data.first?.b64_json
    }
}

/// Structure representing a base64 encoded image
struct Base64: Decodable {
    /// The base64 encoded image data in JSON format
    let b64_json: String
}
