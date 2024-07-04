//
//  AsyncImageErrors.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Enumeration representing the various errors that can occur in `OpenAIAsyncImage`
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum AsyncImageErrors: Error, Equatable {
    
    /// Error indicating that an image could not be created from a `uiImage`
    case imageInit
    
    /// Error indicating that the client was not found, likely due to an invalid URL
    case clientIsNotDefined
    
    /// Error indicating that the response returned no images
    case returnedNoImages
    
}
