# OpenAI DALL·E AsyncImage SwiftUI

SwiftUI view that asynchronously loads and displays an OpenAI image from open API
You just type in any your idea and AI will give you an art solution

DALL-E and DALL-E 2 are deep learning models developed by OpenAI to generate digital images from natural language descriptions, called "prompts"

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fopenai-async-image-swiftui%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/openai-async-image-swiftui)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fopenai-async-image-swiftui%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/openai-async-image-swiftui)

## Features
- [x] Multiplatform iOS, macOS, watchOS and tvOS
- [x] Customizable in term of SwiftUI Image specs [renderingMode, resizable,  antialiased...]
- [x] Customizable in term of the transport layer [Loader]
- [x] Based on interfaces not implementations

 ![OpenAI AsyncImage SwiftUI](https://github.com/The-Igor/openai-async-image-swiftui/blob/main/image/sun_watch.png) 

## How to use

### 1. Get your API key from OpenAI
[Where do I find my Secret API Key?](https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key)


### 2. Override the default loader at Environment with you apiKey

```swift
    let apiKey = "your API KEY"
    let endpoint = OpenAIImageEndpoint.get(with: apiKey)
    let loader = OpenAIDefaultLoader(endpoint: endpoint)
    OpenAIDefaultLoaderKey.defaultValue = loader
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

 ![OpenAI AsyncImage SwiftUI](https://github.com/The-Igor/openai-async-image-swiftui/blob/main/image/appletv_art.png) 

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

## SwiftUI example for the package

[OpenAI AsyncImage SwiftUI example](https://github.com/The-Igor/openai-async-image-swiftui-example)


 ![OpenAI AsyncImage SwiftUI](https://github.com/The-Igor/openai-async-image-swiftui/blob/main/image/sun_11.png) 
