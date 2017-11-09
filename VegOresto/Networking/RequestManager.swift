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
                          keyPath: String? = nil) -> Promise<T> {
        return RequestManager.manager
            .request(url,
                     method: method,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseObject(keyPath: keyPath).then(execute: { (response: DataResponse<T>) -> T in
                return response.value!
            })
    }

    static func doRequest<T: Mappable>(method: HTTPMethod,
                          url: URL,
                          parameters: Parameters? = nil,
                          keyPath: String? = nil) -> Promise<[T]> {
        return RequestManager.manager
            .request(url,
                     method: method,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()
            .responseArray(keyPath: keyPath).then(execute: { (response: DataResponse<[T]>) -> [T] in
                return response.value!
            })
    }

    static func postImageMedia( path: String,
                                imageMedia: UIImage,
                                parameters: Parameters? = nil,
                                completion: @escaping (String) -> Void,
                                failure: @escaping (Error?) -> Void) {

        var urlPath: URLConvertible!

        var request:() -> Void = {}

        request = {

            var header = [ "Authorization": "Bearer " + SecurityServices.shared.getToken() ]
            header["Content-Type"] = "image/jpeg"
            header["Content-Disposition"] = "attachment; filename=\"commentaire.jpg\""

            var urlRequest: URLRequest!

            do {
                try urlPath = (path).asURL()
                urlRequest = try URLRequest(url: urlPath, method: .post, headers: header)

                urlRequest.httpBody = imageMedia.convertToJpg(limiteSize: 2097150)

            } catch {

                return
            }

            RequestManager.manager.request(urlRequest).responseJSON(completionHandler: { (dataResponse) in

                                            if let result = dataResponse.result.value as? [String:Any] {

                                                if let identImage = result["id"] as? Int {
                                                    completion(String(identImage))
                                                } else {
                                                    failure(nil)
                                                }

                                            } else {

                                                print("result fail")
                                                failure(nil)

                                            }

                                           })
        }

        request()

    }

    static func doRequestList(method: HTTPMethod,
                              url: URL,
                              parameters: Parameters? = nil,
                              keyPath: String? = nil) -> Promise<[String : Any]> {
        
        let request = RequestManager.manager
            .request(url,
                     method: method,
                     parameters: parameters,
                     encoding: URLEncoding.default,
                     headers: APIConfig.defaultHTTPHeaders())
            .validate()

        return request.responseJSON().then(execute: { (responseObject: Any) -> [String:Any] in
            guard let responseDict = responseObject as? [String:Any] else {
                throw RequestManagerError.jsonError
            }
            return responseDict
        })
    }

    static func postRequest(  path: String,
                              parameters: Parameters? = nil,
                              keyPath: String? = nil,
                              completion: @escaping ([String : Any]) -> Void,
                              failure: @escaping (Error?) -> Void) {

        let urlPath: URLConvertible!

        do {
            try urlPath = (path).asURL()
        } catch {

            return
        }

        var request:() -> Void = {}
        request = {

            let header = [ "Authorization": "Bearer " + SecurityServices.shared.getToken() ]

            RequestManager.manager.request(urlPath,
                                           method: .post,
                                           parameters: parameters,
                                           encoding: JSONEncoding.default,
                                           headers: header).responseJSON(completionHandler: { (dataResponse) in

                                            if dataResponse.response?.statusCode == 200 || dataResponse.response?.statusCode == 201 || dataResponse.response?.statusCode == 202 {

                                                if let result = dataResponse.result.value as? [String:Any] {

                                                    completion(result)

                                                } else {

                                                    print("result fail")
                                                    failure(nil)

                                                }

                                            } else {

                                                if let result = dataResponse.result.value as? [String:Any] {

                                                    let resultError = NSError(domain: (result["message"] as? String) ?? "", code: dataResponse.response?.statusCode ?? 404, userInfo: nil)

                                                    failure(resultError)
                                                }

                                                failure(nil)

                                            }

                                           })
        }

        request()

    }
}

extension UIImage {

    func convertToJpg(limiteSize: Int) -> Data? {

        // sourceImage is whatever image you're starting with

        var imageData: Data? = nil

        for i in 0...9 {

            imageData = UIImageJPEGRepresentation(self, 1.0 - (0.1 * CGFloat(i)) )

            if (imageData?.count ?? limiteSize) < limiteSize {
                break
            }
        }

        return imageData
    }

}
