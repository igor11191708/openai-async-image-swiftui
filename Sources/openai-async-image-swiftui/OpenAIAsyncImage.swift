//
//  OpenAIAsyncImage.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import SwiftUI

fileprivate typealias ImageSize = OpenAIImageSize

/// Async image component to load and show OpenAI image from OpenAI image API
public struct OpenAIAsyncImage<Content: View, T: IOpenAILoader>: View {
    
    /// Custom view builder tpl
    public typealias ImageProcess = (ImageState) -> Content
        
    /// Default loader
    @Environment(\.openAIDefaultLoader) var defaultLoader : OpenAIDefaultLoader
    
    // MARK: - Private properties
    
    /// OpenAI image
    @State private var image: Image?
        
    /// Error
    @State private var error: Error?
        
    /// Current task
    @State private var task : Task<Void, Never>?
   
    // MARK: - Config
    
    @Binding var prompt : String
        
    /// Custom loader
    let loader : T?
        
    /// Image size
    let size : OpenAIImageSize
        
    /// Custom view builder tpl
    let tpl : ImageProcess?
    
    // MARK: - Life circle
        
    /// - Parameters:
    ///   - prompt: A text description of the desired image(s). The maximum length is 1000 characters
    ///   - size: The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024
    ///   - tpl: Custom view builder tpl
    ///   - loader: Custom loader
    public init(
        prompt : Binding<String>,
        size : OpenAIImageSize = .dpi256,
        @ViewBuilder tpl : @escaping ImageProcess,
        loader : T
    ){
        self._prompt = prompt
        self.size = size
        self.tpl = tpl
        self.loader = loader
    }
    
    /// The content and behavior of the view
    public var body: some View {
        ZStack{
            let state = getState()
            if let tpl {
                tpl(state)
            }else{
                imageTpl(state)
            }
        }
        .onChange(of: prompt){ _ in
            cancelTask()
            clear()
            task = getTask()
        }
        .onAppear {
           task = getTask()
        }
        .onDisappear{
            cancelTask()
        }
    }
    
    // MARK: - Private
       
    /// - Returns: Current image state status
    private func getState () -> ImageState{
        
        if let image { return .loaded(image) }
        else if let error { return .loadError(error)}
        
        return .loading
    }
        
    /// Load using default loader
    /// - Returns: OpenAI image
    private func loadImageDefault(_ prompt : String, with size : ImageSize) async throws -> Image{
        try await defaultLoader.load(prompt, with: size)
    }
    
    /// Load image by text
    /// - Parameters:
    ///   - prompt: Text
    ///   - size: Image size
    /// - Returns: Open AI Image
    private func loadImage(_ prompt : String, with size : ImageSize) async -> Image?{
        do{
            if let loader = loader{
                return try await loader.load(prompt, with: size)
            }
            
            return try await loadImageDefault(prompt, with: size)
        }catch{
            if !Task.isCancelled{
                self.error = error
            }
            
            return nil
        }
    }
    
    /// - Parameter value: OpenAI image
    @MainActor
    private func setImage(_ value : Image){
        image = value
    }
    
    /// Clear properties
    @MainActor
    private func clear(){
        image = nil
        error = nil
    }
    
    private func cancelTask(){
        task?.cancel()
        task = nil
    }
    
    /// - Returns: Task to fetch OpenAI image
    private func getTask() -> Task<Void, Never>{
        Task{
            if let image = await loadImage(prompt, with: size){
                await setImage(image)
            }
        }
    }
}

// MARK: - Extension public -

public extension OpenAIAsyncImage where Content == EmptyView, T == OpenAIDefaultLoader{
    
    
    /// - Parameters:
    ///   - prompt: Text
    ///   - size: Image size
    init(
        prompt : Binding<String>,
        size : OpenAIImageSize = .dpi256
    ){
        self._prompt = prompt
        self.size = size
        self.tpl = nil
        self.loader = nil
    }
}

public extension OpenAIAsyncImage where T == OpenAIDefaultLoader{
    
    /// - Parameters:
    ///   - prompt: Text
    ///   - size: Image size
    ///   - tpl: View tpl
    init(
        prompt : Binding<String>,
        size : OpenAIImageSize = .dpi256,
        @ViewBuilder tpl : @escaping ImageProcess
    ){
        self._prompt = prompt
        self.size = size
        self.tpl = tpl
        self.loader = nil
    }
}

// MARK: - File private -

@ViewBuilder
fileprivate func imageTpl(_ state : ImageState) -> some View{
    switch state{
        case .loaded(let image) : image.resizable()
        case .loadError(let error) : Text(error.localizedDescription)
        case .loading : ProgressView()
    }
}
