//
//  ImageState.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import SwiftUI

/// Enumeration representing the various states of `OpenAIAsyncImage`
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum ImageState {
    
    /// State when the image is currently being loaded
    case loading
    
    /// State when the image has been successfully loaded
    case loaded(Image)
    
    /// State when an error occurred during image fetching
    case loadError(Error)
}
