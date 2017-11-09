//
//  RequestManager.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import PromiseKit
import JWT

extension DataRequest {
    public func responseObject<T: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil) -> Promise<DataResponse<T>> {
        return Promise(resolvers: { (fulfill, reject) in
            self.responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context, completionHandler: { (response: DataResponse<T>) in
                if let error = response.error {
                    reject(error)
                } else if response.value != nil {
                    fulfill(response)
                } else {
                    reject(PMKError.invalidCallingConvention)
                }
            })
        })
    }

    public func responseArray<T: Mappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, context: MapContext? = nil) -> Promise<DataResponse<[T]>> {
        return Promise(resolvers: { (fulfill, reject) in
            self.responseArray(queue: queue, keyPath: keyPath, context: context, completionHandler: { (response: DataResponse<[T]>) in
                if let error = response.error {
                    reject(error)
                } else if response.value != nil {
                    fulfill(response)
                } else {
                    reject(PMKError.invalidCallingConvention)
                }
            })
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
            .responseObject(keyPath: keyPath).then(execute: { (response: DataResponse<T>) -> T in
                return response.value!
            })
    }
    
    public func get<T: Mappable>(url: URL, parameters: Parameters? = nil, keyPath: String? = nil) -> Promise<[T]> {
        return session
            .request(url,
                     parameters: parameters,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseArray(keyPath: keyPath).then(execute: { (response: DataResponse<[T]>) -> [T] in
                return response.value!
            })
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
