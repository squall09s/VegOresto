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

class RequestManager: NSObject {

    static let manager: SessionManager = RequestManager.buildManager()

    private static func buildManager() -> SessionManager {

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.httpShouldSetCookies = false

        let sessionManager = SessionManager(
            configuration: configuration

        )

        return sessionManager
    }

    static func doRequest<T: Mappable>(method: HTTPMethod,
                          path: String,
                          parameters: Parameters? = nil,
                          keyPath: String? = nil,
                          completion: @escaping (T) -> Void,
                          failure: @escaping (Error?) -> Void) {

        let urlPath: URLConvertible!

        do {
            try urlPath = (path).asURL()
        } catch {

            return
        }

        var request:() -> Void = {}
        request = {

            RequestManager.manager.request(urlPath,
                                           method: method,
                                           parameters: parameters,
                                           encoding: JSONEncoding.default,
                                           headers: HTTPHEADER())
                .validate()
                .responseObject( keyPath: keyPath,
                                 completionHandler: { (response: DataResponse<T>) -> Void in

                                    if response.result.isSuccess {
                                        if let data = response.result.value {
                                            completion(data)
                                        } else {
                                            failure(nil)
                                        }
                                    }

                })
        }

        request()

    }

    static func doRequest<T: Mappable>(method: HTTPMethod,
                          path: String,
                          parameters: Parameters? = nil,
                          keyPath: String? = nil,
                          completion: @escaping ([T]) -> Void,
                          failure: @escaping (Error?) -> Void) {

        let urlPath: URLConvertible!

        do {
            try urlPath = (path).asURL()
        } catch {

            return
        }

        var request:() -> Void = {}

        request = {

            RequestManager.manager.request(urlPath,
                                           method: method,
                                           parameters: parameters,
                                           encoding: JSONEncoding.default,
                                           headers: HTTPHEADER())
                .validate()
                .responseArray( keyPath: keyPath,
                                completionHandler: { (response: DataResponse<[T]>) -> Void in

                                    if response.result.isSuccess {
                                        if let data = response.result.value {
                                            completion(data)
                                        } else {
                                            failure(nil)
                                        }
                                    }

                })
        }

        request()

    }

    static func doRequestListGzipped(method: HTTPMethod,
                              path: String,
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

            RequestManager.manager.request(urlPath,
                                           method: method,
                                           parameters: parameters,
                                           encoding: URLEncoding.default,
                                           headers: HTTPHEADER()).responseData(completionHandler: { (dataResponse) in

                                            // gunzip
                                            if let compressedData: NSData = dataResponse.result.value as NSData?, compressedData.isGzippedData() {

                                                    let decompressedData = try! compressedData.gunzipped()

                                                    let stringValue = String(bytes: decompressedData!, encoding: String.Encoding.utf8)

                                                    if let result: [String : Any] = RequestManager.convertToDictionary(text: stringValue ?? "") {

                                                        print("--> result \(result)")
                                                        completion(result)

                                                    }

                                                } else {

                                                    failure(nil)
                                                }

                                           })
        }

        request()

    }

    static func doRequestList(method: HTTPMethod,
                              path: String,
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

            RequestManager.manager.request(urlPath,
                                           method: method,
                                           parameters: parameters,
                                           encoding: JSONEncoding.default,
                                           headers: HTTPHEADER()).responseJSON(completionHandler: { (dataResponse) in

                                            print("--> url \(urlPath)")
                                            print("--> response \(dataResponse.result.value)")

                                            if let result = dataResponse.result.value as? [String:Any] {

                                                print("--> result \(result)")
                                                completion(result)

                                            } else {

                                                failure(nil)

                                            }

                                           })
        }

        request()

    }

    static func postRequest(  path: String,
                              parameters: Parameters? = nil,
                              keyPath: String? = nil,
                              completion: @escaping (Bool) -> Void,
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

                                            if let result = dataResponse.result.value as? [String:Any] {

                                                print("result success = \(result)")
                                                completion(true)

                                            } else {

                                                print("result fail")
                                                failure(nil)

                                            }

                                           })
        }

        request()

    }

    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
