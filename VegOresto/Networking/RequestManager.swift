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

    public func responseObject<T: Mappable>(keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil) -> Promise<T> {
        return self.responseJSON(keyPath: keyPath).then(execute: { (JSONObject: Any) -> T in
            guard let _JSONObject = JSONObject as? [String:Any] else {
                throw RequestManagerError.jsonError
            }
            if let _object = object {
                _ = Mapper<T>(context: context).map(JSONObject: _JSONObject, toObject: _object)
                return _object
            } else if let parsedObject = Mapper<T>(context: context).map(JSONObject: _JSONObject){
                return parsedObject
            }
            throw RequestManagerError.jsonError
        })
    }

    public func responseArray<T: Mappable>(keyPath: String? = nil, context: MapContext? = nil) -> Promise<[T]> {
        return self.responseJSON(keyPath: keyPath).then(execute: { (JSONObject: Any) -> [T] in
            guard let parsedObject = Mapper<T>(context: context, shouldIncludeNilValues: false).mapArray(JSONObject: JSONObject) else {
                throw PMKError.invalidCallingConvention
            }
            return parsedObject
        })
    }
}

enum RequestManagerError: Error {
    case gzipError
    case jsonError
    case imageCreationError
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
    
    public func get<T: Mappable>(url: URL, parameters: Parameters? = nil, keyPath: String? = nil) -> Promise<T> {
        return session
            .request(url,
                     parameters: parameters,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseObject(keyPath: keyPath)
    }
    
    public func get<T: Mappable>(url: URL, parameters: Parameters? = nil, keyPath: String? = nil) -> Promise<[T]> {
        return session
            .request(url,
                     parameters: parameters,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseArray(keyPath: keyPath)
    }

    public func get(url: URL, parameters: Parameters? = nil) -> Promise<Any> {
        return session
            .request(url,
                     parameters: parameters,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseJSON()
    }

    public func get(url: URL, parameters: Parameters? = nil) -> Promise<[String : Any]> {
        return get(url: url, parameters: parameters).then(execute: { (responseObject: Any) -> [String:Any] in
            guard let responseDict = responseObject as? [String:Any] else {
                throw RequestManagerError.jsonError
            }
            return responseDict
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

        return session.request(urlRequest).responseJSON()
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
