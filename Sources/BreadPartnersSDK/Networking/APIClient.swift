//------------------------------------------------------------------------------
//  File:          APIClient.swift
//  Author(s):     Bread Financial
//  Date:          27 March 2025
//
//  Descriptions:  This file is part of the BreadPartnersSDK for iOS,
//  providing UI components and functionalities to integrate Bread Financial
//  services into partner applications.
//
//  © 2025 Bread Financial
//------------------------------------------------------------------------------

import Foundation

struct AnySendable: @unchecked Sendable {
    let value: Any
}
/// Enum for HTTP Method Types.
internal enum HTTPMethod: String, Sendable {
    case GET, POST, PUT, DELETE, OPTIONS
}

/// A utility class for making HTTP API requests.
internal class APIClient: @unchecked Sendable {

    init(
        logger: Logger
    ) {
        self.logger = logger
    }

    var logger: Logger = Logger()
    
    /// Generic API call function
    ///
    /// - Parameters:
    ///   - urlString: The URL endpoint as a string.
    ///   - method: HTTP method (e.g., "GET", "POST").
    ///   - body: Optional request body, can be a dictionary (`[String: Any]`) or a Codable model.
    ///   - headers: Optional headers body, can be a dictionary (`[String: Any]`) or nil.
    ///   - completion: Closure to handle the result, returning a success with response or failure with error.
    func request(
        urlString: String,
        method: HTTPMethod = .POST,
        headers: [String: String]? = nil,
        body: Any? = nil
    ) async throws -> AnySendable {
        // Validate the URL
        guard let url = URL(string: urlString) else {
            throw NSError(
                domain: "InvalidURL", code: 400,
                userInfo: [
                    NSLocalizedDescriptionKey: "The URL provided is invalid."
                ])
        }

        // Configure the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let genericHeader: [String: String] = await [
            Constants.headerContentType: Constants.headerContentTypeValue,
            Constants.headerUserAgentKey: CommonUtils().getUserAgent(),
            Constants.headerOriginKey: Constants.headerOriginValue,
        ]

        let updatedHeaders = (headers ?? [:]).merging(
            genericHeader, uniquingKeysWith: { first, _ in first })

        for (key, value) in updatedHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Add body if provided
        if let body = body {
            do {
                let jsonData: Data

                let unwrappedBody = (body as? AnySendable)?.value ?? body

                if let bodyDictionary = unwrappedBody as? [String: Any] {
                    jsonData = try JSONSerialization.data(
                        withJSONObject: bodyDictionary, options: [])
                } else if let bodyCodable = unwrappedBody as? Encodable {
                    let encoder = JSONEncoder()
                    encoder.keyEncodingStrategy = .useDefaultKeys
                    jsonData = try encoder.encode(bodyCodable)
                } else {
                    throw NSError(
                        domain: "UnsupportedBodyType", code: 400,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "The request body type is not supported. Type: \(type(of: unwrappedBody))"
                        ]
                    )
                }

                request.httpBody = jsonData
            } catch {
                throw NSError(
                    domain: "SerializationError", code: 500,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Failed to serialize the request body."
                    ]
                )
            }
        }

        // Log the request details
        logger.logRequestDetails(
            url: url,
            method: method.rawValue,
            headers: updatedHeaders,
            body: request.httpBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(
                domain: "InvalidResponse", code: 500,
                userInfo: [
                    NSLocalizedDescriptionKey: "Invalid response from server."
                ])
        }

        logger.logResponseDetails(
            url: url, statusCode: httpResponse.statusCode,
            headers: httpResponse.allHeaderFields, body: data)

        // Validate HTTP status code
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "HTTPError", code: httpResponse.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Server returned an error: \(httpResponse.statusCode)"
                ])
        }

        // Decode the response data
        do {

            if let jsonDict = try JSONSerialization.jsonObject(
                with: data, options: []) as? [String: Any]
            {
                return AnySendable(value: jsonDict)
            } else {
                throw NSError(
                    domain: "BreadPartnersSDKSwift", code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]
                )
            }
        } catch {
            throw NSError(
                domain: "DecodingError", code: 500,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Failed to decode the server response."
                ])
        }

    }
}
