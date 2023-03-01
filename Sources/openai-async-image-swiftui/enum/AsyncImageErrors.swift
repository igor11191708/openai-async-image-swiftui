//
//  AsyncImageErrors.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Set of errors for ``OpenAIAsyncImage``
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum AsyncImageErrors: Error, Equatable{
    
    /// Could not create Image from uiImage
    case imageInit
    
    /// Client not found - the reason url in not valid
    case clientIsNotDefined
    
    /// response returned no images
    case returnedNoImages
    
    /// Status is not 200
    case status(Int)
    
}
