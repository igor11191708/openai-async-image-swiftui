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
    
    /// Dall-e model type
    let model : DalleModel
    
    // MARK: - Life cycle
        
    /// Initializes a view model for generating images using the OpenAI API with customizable parameters.
    /// - Parameters:
    ///   - prompt: A `Binding` to a `String` that represents a text description of the desired image(s).
    ///             The maximum length for the prompt is 1000 characters.
    ///   - size: The size of the generated images, specified as an `OpenAIImageSize`.
    ///           Defaults to `.dpi256`. Must be one of `.dpi256` (256x256), `.dpi512` (512x512), or `.dpi1024` (1024x1024).
    ///   - model: The `DalleModel` specifying which model to use for generating the image(s).
    ///            Defaults to `.dalle2`.
    ///   - tpl: A custom SwiftUI `ViewBuilder` template for processing or rendering the generated image(s).
    ///   - loader: A custom loader conforming to the `IOpenAILoader` protocol, responsible for handling
    ///             the image generation process, such as communicating with the OpenAI API.
    public init(
        prompt: Binding<String>,
        size: OpenAIImageSize = .dpi256,
        model: DalleModel = .dalle2,
        @ViewBuilder tpl: @escaping ImageProcess,
        loader: T
    ) {
        self._prompt = prompt
        self.size = size
        self.model = model
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
        
    /// Loads an image using the default loader.
    /// - Parameters:
    ///   - prompt: The text prompt describing the desired image content.
    ///   - size: The dimensions of the generated image, specified as `ImageSize`.
    ///   - model: The `DalleModel` specifying the AI model to use for image generation.
    /// - Returns: A generated `Image` object if successful.
    /// - Throws: An error if the image generation fails.
    private func loadImageDefault(
        _ prompt: String,
        with size: ImageSize,
        model: DalleModel
    ) async throws -> Image {
        try await defaultLoader.load(prompt, with: size, model: model)
    }

    /// Loads an image using a provided loader, or falls back to the default loader if none is provided.
    /// - Parameters:
    ///   - prompt: The text prompt describing the desired image content.
    ///   - size: The dimensions of the generated image, specified as `ImageSize`.
    ///   - model: The `DalleModel` specifying the AI model to use for image generation.
    /// - Returns: An `Image` object if successful, or `nil` if the operation fails or is cancelled.
    private func loadImage(
        _ prompt: String,
        with size: ImageSize,
        model: DalleModel
    ) async -> Image? {
        do {
            if let loader = loader {
                return try await loader.load(prompt, with: size, model: model)
            }
            return try await loadImageDefault(prompt, with: size, model: model)
        } catch {
            if !Task.isCancelled {
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
            if let image = await loadImage(prompt, with: size, model: model){
                await setImage(image)
            }
        }
    }
}

// MARK: - Public extensions -

public extension OpenAIAsyncImage where Content == EmptyView, T == OpenAIDefaultLoader{
    
    /// Convenience initializer for creating an instance with the default loader and no custom view template.
    /// - Parameters:
    ///   - prompt: A `Binding` to a `String` containing the text prompt that describes the desired image content.
    ///   - size: The desired size of the generated image, specified as an `OpenAIImageSize`.
    ///           Defaults to `.dpi256`.
    ///   - model: The `DalleModel` specifying the AI model to use for image generation. Defaults to `.dalle2`.
    init(
        prompt: Binding<String>,
        size: OpenAIImageSize = .dpi256,
        model: DalleModel = .dalle2
    ) {
        self._prompt = prompt
        self.size = size
        self.model = model
        self.tpl = nil
        self.loader = nil
    }
}

public extension OpenAIAsyncImage where T == OpenAIDefaultLoader{
    
    /// Convenience initializer for creating an instance with the default loader and a custom view template.
    /// - Parameters:
    ///   - prompt: A `Binding` to a `String` containing the text prompt that describes the desired image content.
    ///   - size: The desired size of the generated image, specified as an `OpenAIImageSize`. Defaults to `.dpi256`.
    ///   - model: The `DalleModel` specifying the AI model to use for image generation. Defaults to `.dalle2`.
    ///   - tpl: A SwiftUI `@ViewBuilder` closure that provides a custom view template for processing or rendering the generated image.
    init(
        prompt: Binding<String>,
        size: OpenAIImageSize = .dpi256,
        model: DalleModel = .dalle2,
        @ViewBuilder tpl: @escaping ImageProcess
    ) {
        self._prompt = prompt
        self.size = size
        self.model = model
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
