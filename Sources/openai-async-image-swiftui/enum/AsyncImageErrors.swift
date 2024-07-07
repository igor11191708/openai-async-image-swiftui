//
//  AsyncImageErrors.swift
//
//
//  Created by Igor on 18.02.2023.
//

import Foundation
import async_http_client

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
/// Enum representing different errors that can occur when loading images asynchronously
enum AsyncImageErrors: Error {
    case imageInit               // Error initializing an image from data
    case clientIsNotDefined      // HTTP client is not defined
    case returnedNoImages        // No images were returned in the response
    case httpStatus(String)      // HTTP status error with a message
    case responseError(Error)    // Generic response error
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
        case .httpStatus(let status):
            return NSLocalizedString("HTTP status error: \(status).", comment: "")
        case .responseError(let error):
            return error.localizedDescription
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AsyncImageErrors {
    /// Handles errors that occur during the request
    /// - Parameter error: The error that occurred
    /// - Returns: An instance of `AsyncImageErrors`
    static func handleRequest(_ error: Error) -> AsyncImageErrors {
        if let httpError = error as? Http.Errors,
           case let .status(_, _, data) = httpError,
           let responseData = data {
            return decodeErrorResponse(from: responseData)
        }
        return .responseError(error)
    }
}

/// Decodes the error response data
/// - Parameter responseData: The response data to decode
/// - Returns: An instance of `AsyncImageErrors` with a decoded message
fileprivate func decodeErrorResponse(from responseData: Data) -> AsyncImageErrors {
    if let apiResponse = try? JSONDecoder().decode(ErrorResponseWrapper.self, from: responseData) {
        return .httpStatus(apiResponse.error.message)
    }
    
    let dataString = String(data: responseData, encoding: .utf8) ?? "Unable to decode data"
    return .httpStatus(dataString)
}

/// Defines the structure for the inner "error" object in the API response
fileprivate struct ErrorResponse: Decodable {
    let code: String?
    let message: String
    let param: String?
    let type: String
}

/// Defines the structure for the overall response wrapper containing the error object
fileprivate struct ErrorResponseWrapper: Decodable {
    let error: ErrorResponse
}
