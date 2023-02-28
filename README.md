# OpenAI AsyncImage SwiftUI

SwiftUI view that asynchronously loads and displays an OpenAI image from open API

## Features
- [x] Multiplatform
- [x] Customizable in term of SwiftUI Image specs [renderingMode, resizable,  antialiased...]
- [x] Based on interfaces not implementations

 ![OpenAI AsyncImage SwiftUI](https://github.com/The-Igor/openai-async-image-swiftui/blob/main/image/sun.png) 

## How to use

### 1. Get your API key from OpenAI
[Where do I find my Secret API Key?](https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key)


### 2. Override default loader at Environment with you apiKey
```swift
    @Environment(\.openAIDefaultLoader) var loader : OpenAIDefaultLoader
    
        let apiKey = "*******************"
        let endpoint = OpenAIImageEndpoint.get(with: apiKey)
        let loader = OpenAIDefaultLoader(endpoint: endpoint)
        
         ContentView()
                .environment(\.openAIDefaultLoader, loader)
```

### 3. Add **OpenAIAsyncImage** to your code

```swift
        OpenAIAsyncImage(prompt: .constant("sun"))
                       .frame(width: 125, height: 125)
```
or with custom **ViewBuilder**

```swift
        OpenAIAsyncImage(prompt: $imageText, size: .dpi1024){ state in
            switch state{
                case .loaded(let image) :
                image
                    .resizable()
                    .scaledToFill()
                case .loadError(let error) : Text(error.localizedDescription)
                case .loading : ProgressView()
            }
        }
```

| Param | Description |
| --- | --- |
| prompt | A text description of the desired image(s). The maximum length is 1000 characters |
| size | The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024 |
| tpl | Custom view builder tpl |
| loader | Custom loader if you need something specific|


## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

## SwiftUI example for the package

[OpenAI AsyncImage SwiftUI example](https://github.com/The-Igor/openai-async-image-swiftui-example)
