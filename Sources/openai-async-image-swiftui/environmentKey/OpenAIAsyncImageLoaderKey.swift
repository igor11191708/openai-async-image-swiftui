//
//  OpenAIAsyncImageLoaderKey.swift
//  
//
//  Created by Igor on 28.02.2023.
//

import SwiftUI

/// A key for accessing default loader in the environment
public struct OpenAIDefaultLoaderKey : EnvironmentKey{
    public typealias Value = OpenAIDefaultLoader
    
    public static var defaultValue = OpenAIDefaultLoader(endpoint: OpenAIImageEndpoint.get(with: ""))
}

public extension EnvironmentValues{
    var openAIDefaultLoader: OpenAIDefaultLoader{
        get { self[OpenAIDefaultLoaderKey.self] }
        set { self[OpenAIDefaultLoaderKey.self] = newValue }
    }
}
