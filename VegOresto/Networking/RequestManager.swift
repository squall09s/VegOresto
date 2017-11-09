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
import GZIP
import PromiseKit

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
    static let manager: SessionManager = RequestManager.buildManager()

    private static func buildManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpShouldSetCookies = false

        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }

    static func doRequest<T: Mappable>(method: HTTPMethod,
                          url: URL,
                          parameters: Parameters? = nil,
                          encoding: ParameterEncoding = URLEncoding.default,
                          keyPath: String? = nil) -> Promise<T> {
        return RequestManager.manager
            .request(url,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseObject(keyPath: keyPath).then(execute: { (response: DataResponse<T>) -> T in
                return response.value!
            })
    }

    static func doRequest<T: Mappable>(method: HTTPMethod,
                          url: URL,
                          parameters: Parameters? = nil,
                          encoding: ParameterEncoding = URLEncoding.default,
                          keyPath: String? = nil) -> Promise<[T]> {
        return RequestManager.manager
            .request(url,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseArray(keyPath: keyPath).then(execute: { (response: DataResponse<[T]>) -> [T] in
                return response.value!
            })
    }

    static func postImageMedia(url: URL, image: UIImage) -> Promise<String> {
        // get image data
        guard let imageData = image.jpegRepresentation(sizeLimit: 2097150) else {
            return Promise(error: RequestManagerError.imageCreationError)
        }

        // create request
        let headers = [
            "Authorization": "Bearer \(SecurityServices.shared.getToken())",
            "Content-Type": "image/jpeg",
            "Content-Disposition": "attachment; filename=\"commentaire.jpg\"",
        ]
        var urlRequest = try! URLRequest(url: url, method: .post, headers: headers)
        urlRequest.httpBody = imageData

        return RequestManager.manager.request(urlRequest).responseJSON().then(execute: { (object: Any) -> String in
            guard let dict = object as? [String:Any],
                  let imageId = dict["id"] as? Int else {
                throw RequestManagerError.jsonError
            }
            return String(imageId)
        })
    }

    static func doRequestList(method: HTTPMethod,
                              url: URL,
                              parameters: Parameters? = nil,
                              encoding: ParameterEncoding = URLEncoding.default,
                              keyPath: String? = nil) -> Promise<[String : Any]> {
        
        let request = RequestManager.manager
            .request(url,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()

        return request.responseJSON().then(execute: { (responseObject: Any) -> [String:Any] in
            guard let responseDict = responseObject as? [String:Any] else {
                throw RequestManagerError.jsonError
            }
            return responseDict
        })
    }

    static func postRequest(url: URL,
                            parameters: Parameters? = nil,
                            encoding: ParameterEncoding = URLEncoding.default,
                            keyPath: String? = nil) -> Promise<[String:Any]> {
        let headers = [
            "Authorization": "Bearer \(SecurityServices.shared.getToken())"
        ]
        let request = RequestManager.manager
            .request(url,
                     method: .post,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headers)
            .validate()

        return request.responseJSON().then(execute: { (object: Any) -> [String:Any] in
            guard let dict = object as? [String:Any] else {
                throw RequestManagerError.jsonError
            }
            return dict
        })
    }
}
