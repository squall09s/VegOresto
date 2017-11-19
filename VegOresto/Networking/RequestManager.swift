//
//  RequestManager.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper
import PromiseKit
import JWT

extension DataRequest {
    private func responseJSON(keyPath: String? = nil, options: JSONSerialization.ReadingOptions = .allowFragments) -> Promise<Any> {
        return self.responseJSON(options: options).then(execute: { (JSONObject: Any) -> Any in
            if let _keyPath = keyPath, !_keyPath.isEmpty {
                if let object = (JSONObject as AnyObject?)?.value(forKeyPath: _keyPath) {
                    return object
                }
                throw RequestManagerError.jsonError
            }
            return JSONObject
        })
    }
}

enum RequestManagerError: Error {
    case gzipError
    case jsonError
    case imageCreationError
    case localDataError
}

class RequestManager {
    static let shared = RequestManager()

    let session: SessionManager
    
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpShouldSetCookies = false
        session = SessionManager(configuration: configuration)
    }
    
    // MARK: Utils

    private func getToken() -> String {
        let claims: [String:Any] = [
            "iat": Date().timeIntervalSince1970,
            "iss": APIConfig.apiClientIss
        ]
        let headers: [String:String] = [
            "kid": APIConfig.apiClientId
        ]
        return JWT.encode(claims: claims, algorithm: .hs256(APIConfig.apiClientSecret.data(using: .utf8)!), headers: headers)
    }

    // MARK: Request Methods
    
    /// Gets any object.
    /// Sends a GET request to the given URL and returns the JSON object.
    ///
    /// - Parameters:
    ///   - url: URL to query.
    ///   - parameters: HTTP query parameters.
    /// - Returns: A promise resolving to a JSON object.
    public func get(url: URL, parameters: Parameters? = nil) -> Promise<Any> {
        return session
            .request(url,
                     parameters: parameters,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseJSON()
    }

    /// Gets a dictionary.
    /// Sends a GET request to the given URL and returns the JSON dictionary.
    ///
    /// - Parameters:
    ///   - url: URL to query.
    ///   - parameters: HTTP query parameters.
    /// - Returns: A promise resolving to a JSON dictionary.
    public func get(url: URL, parameters: Parameters? = nil) -> Promise<[String:Any]> {
        return get(url: url, parameters: parameters).then(execute: { (responseObject: Any) -> [String:Any] in
            guard let responseDict = responseObject as? [String:Any] else {
                throw RequestManagerError.jsonError
            }
            return responseDict
        })
    }

    /// Gets an array of dictionaries.
    /// Sends a GET request to the given URL and returns the JSON array.
    ///
    /// - Parameters:
    ///   - url: URL to query.
    ///   - parameters: HTTP query parameters.
    /// - Returns: A promise resolving to a JSON array of dictionaries.
    public func get(url: URL, parameters: Parameters? = nil) -> Promise<[[String:Any]]> {
        return get(url: url, parameters: parameters).then(execute: { (responseObject: Any) -> [[String:Any]] in
            guard let responseArray = responseObject as? [[String:Any]] else {
                throw RequestManagerError.jsonError
            }
            return responseArray
        })
    }

    public func post(url: URL, image: UIImage, filename: String = "commentaire.jpg") -> Promise<Any> {
        // get image data
        guard let imageData = image.jpegRepresentation(sizeLimit: 2097150) else {
            return Promise(error: RequestManagerError.imageCreationError)
        }

        // create request
        let headers = [
            "Authorization": "Bearer \(getToken())",
            "Content-Type": "image/jpeg",
            "Content-Disposition": "attachment; filename=\"\(filename)\"",
        ]
        var urlRequest = try! URLRequest(url: url, method: .post, headers: headers)
        urlRequest.httpBody = imageData

        return session.request(urlRequest).validate().responseJSON()
    }

    public func post(url: URL, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default) -> Promise<Any> {
        let headers = [
            "Authorization": "Bearer \(getToken())"
        ]
        return session
            .request(url,
                     method: .post,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers)
            .validate()
            .responseJSON()
    }
}
