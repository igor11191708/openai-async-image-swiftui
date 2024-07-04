//
//  OpenAIAsyncImage.swift
//
//
//  Created by Igor on 18.02.2023.
//

import SwiftUI

fileprivate typealias ImageSize = OpenAIImageSize

/// Async image component to load and show OpenAI image from OpenAI image API
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct OpenAIAsyncImage<Content: View, T: IOpenAILoader>: View {
    
    /// Custom view builder template type alias
    public typealias ImageProcess = (ImageState) -> Content
        
    /// Default loader, injected from environment
    @Environment(\.openAIDefaultLoader) var defaultLoader : OpenAIDefaultLoader
    
    // MARK: - Private properties
    
    /// State variable to hold the OpenAI image
    @State private var image: Image?
        
    /// State variable to hold any errors encountered during loading
    @State private var error: Error?
        
    /// State variable to hold the current task responsible for loading the image
    @State private var task : Task<Void, Never>?
   
    // MARK: - Config
    
    /// A binding to the text prompt describing the desired image. The maximum length is 1000 characters
    @Binding var prompt : String
        
    /// Optional custom loader conforming to `IOpenAILoader` protocol
    let loader : T?
        
    /// The size of the image to be generated
    let size : OpenAIImageSize
        
    /// Optional custom view builder template
    let tpl : ImageProcess?
    
    // MARK: - Life cycle
        
    /// - Parameters:
    ///   - prompt: A text description of the desired image(s). The maximum length is 1000 characters
    ///   - size: The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024
    ///   - tpl: Custom view builder template
    ///   - loader: Custom loader conforming to `IOpenAILoader`
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
    
    // MARK: - Private methods
       
    /// - Returns: The current image state status
    private func getState () -> ImageState{
        
        if let image { return .loaded(image) }
        else if let error { return .loadError(error)}
        
        return .loading
    }
        
    /// Load using the default loader
    /// - Parameters:
    ///   - prompt: The text prompt for generating the image
    ///   - size: The desired size of the image
    /// - Returns: OpenAI image
    private func loadImageDefault(_ prompt : String, with size : ImageSize) async throws -> Image{
        try await defaultLoader.load(prompt, with: size)
    }
    
    /// Load image using the provided or default loader
    /// - Parameters:
    ///   - prompt: The text prompt for generating the image
    ///   - size: The desired size of the image
    /// - Returns: OpenAI image if successful, otherwise nil
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
    
    /// Sets the image on the main thread
    /// - Parameter value: The image to be set
    @MainActor
    private func setImage(_ value : Image){
        image = value
    }
    
    /// Clears the image and error state properties
    @MainActor
    private func clear(){
        image = nil
        error = nil
    }
    
    /// Cancels the current loading task if any
    private func cancelTask(){
        task?.cancel()
        task = nil
    }
    
    /// Creates and returns a task to fetch the OpenAI image
    /// - Returns: A task that fetches the OpenAI image
    private func getTask() -> Task<Void, Never>{
        Task{
            if let image = await loadImage(prompt, with: size){
                await setImage(image)
            }
        }
    }
}

// MARK: - Public extensions -

public extension OpenAIAsyncImage where Content == EmptyView, T == OpenAIDefaultLoader{
    
    /// Convenience initializer for default loader without custom view template
    /// - Parameters:
    ///   - prompt: The text prompt for generating the image
    ///   - size: The desired size of the image
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
    
    /// Convenience initializer for default loader with custom view template
    /// - Parameters:
    ///   - prompt: The text prompt for generating the image
    ///   - size: The desired size of the image
    ///   - tpl: Custom view template
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

// MARK: - File private functions -

@ViewBuilder
fileprivate func imageTpl(_ state : ImageState) -> some View{
    switch state{
        case .loaded(let image) : image.resizable()
        case .loadError(let error) : Text(error.localizedDescription)
        case .loading : ProgressView()
    }
}
