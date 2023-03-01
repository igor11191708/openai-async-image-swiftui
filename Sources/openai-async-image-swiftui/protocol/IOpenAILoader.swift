//
//  IOpenAILoader.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import SwiftUI

/// Loader for getting images
@available(iOS 15.0, macOS 12.0, *)
public protocol IOpenAILoader{
       
    /// Load image by text
    /// - Parameters:
    ///   - prompt: Text
    ///   - size: Image size
    /// - Returns: Open AI Image
    func load(_ prompt : String, with size : OpenAIImageSize) async throws  -> Image
}
