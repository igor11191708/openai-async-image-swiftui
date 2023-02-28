//
//  AsyncImageErrors.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

/// Set of errors for ``OpenAIAsyncImage``
enum AsyncImageErrors: Error, Equatable{
    
    /// Could not create Image from uiImage
    case imageInit
    
    /// Client not found - the reason url in not valid
    case clientIsNotDefined
    
    /// response returned no images
    case returnedNoImages
    
    case status(Int)
    
}
