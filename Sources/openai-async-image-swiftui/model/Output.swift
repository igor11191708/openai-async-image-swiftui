//
//  Response.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Output format for OpenAI API
struct Output: Decodable{
    
    /// Date and time
    let created : Int
    
    /// Set of images
    let data: [Base64]
        
    /// Fist image from the recieved data set
    var firstImage : String?{
        data.first?.b64_json
    }
}

struct Base64: Decodable{
    let b64_json : String
}
