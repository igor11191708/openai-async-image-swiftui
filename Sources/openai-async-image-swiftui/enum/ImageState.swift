//
//  ImageState.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import SwiftUI

/// Set of states  for ``OpenAIAsyncImage``
public enum ImageState{
    
    /// Loading currently
    case loading
    
    /// Loaded
    case loaded(Image)
    
    /// There's an error happend while fetching
    case loadError(Error)
    
}
