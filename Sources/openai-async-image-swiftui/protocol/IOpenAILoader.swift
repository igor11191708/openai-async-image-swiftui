//
//  IOpenAILoader.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import SwiftUI

/// Protocol defining the loader for fetching images from the OpenAI API
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol IOpenAILoader {
       
    /// Asynchronously loads an image based on a provided text prompt and size
    /// - Parameters:
    ///   - prompt: The text prompt describing the desired image
    ///   - size: The size of the generated image
    /// - Returns: The generated OpenAI image
    func load(_ prompt: String, with size: OpenAIImageSize) async throws -> Image
}
