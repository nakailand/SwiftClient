//
//  API.swift
//  SwiftClient
//
//  Created by nakazy on 2016/02/18.
//  Copyright © 2016年 nakazy. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

extension Session {
    public static func rx_response<T: RequestType>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = sendRequest(request) { result in
                switch result {
                case .Success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let t = task
            t?.resume()
            
            return AnonymousDisposable {
                task?.cancel()
            }
        }
    }
}

protocol ADRequest: RequestType {
}

extension ADRequest {
    var baseURL: NSURL {
        return NSURL(string: "http://swift-vapor.herokuapp.com")!
    }
}

// 全ての質問を取得する
struct Hello: ADRequest {
    typealias Response = String
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return "/hello"
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let dictionary = object as? [String: AnyObject] else {
            return nil
        }
        return dictionary["Hello"] as? String
    }
}