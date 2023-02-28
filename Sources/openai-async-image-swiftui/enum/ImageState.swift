//
//  ImageState.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import SwiftUI

/// Set of states  for ``OpenAIAsyncImage``
@available(iOS 15.0, macOS 12.0, *)
public enum ImageState{
    
    /// Loading currently
    case loading
    
    /// Loaded
    case loaded(Image)
    
    /// There's an error happened while fetching
    case loadError(Error)
    
}
