//
//  AsyncImageErrors.swift
//  
//
//  Created by Igor on 18.02.2023.
//

import Foundation

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum AsyncImageErrors: Error, Equatable {
    
    /// Error indicating that an image could not be created from a `uiImage`
    case imageInit
    
    /// Error indicating that the client was not found, likely due to an invalid URL
    case clientIsNotDefined
    
    /// Error indicating that the response returned no images
    case returnedNoImages
    
    /// Status is not valid
    case httpStatus(String)
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AsyncImageErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageInit:
            return NSLocalizedString("Unable to create image from the provided data.", comment: "")
        case .clientIsNotDefined:
            return NSLocalizedString("Client not found. The URL might be invalid.", comment: "")
        case .returnedNoImages:
            return NSLocalizedString("The response did not contain any images.", comment: "")
        case .httpStatus(let data):
            return NSLocalizedString("HTTP status error: \(data).", comment: "")
        }
    }
}
