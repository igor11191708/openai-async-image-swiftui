//
//  ImageSize.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024
@available(iOS 15.0, macOS 12.0, *)
public enum OpenAIImageSize: String, Encodable{
    
    case dpi256 = "256x256"
    
    case dpi512 = "512x512"
    
    case dpi1024 = "1024x1024"
}
