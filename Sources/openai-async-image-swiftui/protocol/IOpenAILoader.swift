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
       
    /// Asynchronously generates an image using a given text prompt, size, and model.
    /// - Parameters:
    ///   - prompt: A descriptive text prompt that defines the content of the desired image.
    ///   - size: The dimensions of the generated image, specified as an `OpenAIImageSize`.
    ///   - model: The `DalleModel` used for image generation.
    /// - Returns: A generated `Image` based on the provided prompt and size.
    /// - Throws: An error if the image generation process fails, such as issues with the prompt, model, or network.
    func load(_ prompt: String, with size: OpenAIImageSize,
              model: DalleModel) async throws -> Image
}
