//
//  OpenAIImageRequest.swift
//  
//
//  Created by Igor on 18.02.2023.
// https://platform.openai.com/docs/api-reference/images

import Foundation


/// Input format to OpenAI API
@available(iOS 15.0, macOS 12.0, *)
struct Input: Encodable{
        
    /// A text description of the desired image(s). The maximum length is 1000 characters
    let prompt: String
    
    /// The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024
    let size : OpenAIImageSize
    
    /// The format in which the generated images are returned. Must be one of url or b64_json
    let response_format : ResponseFormat
}
