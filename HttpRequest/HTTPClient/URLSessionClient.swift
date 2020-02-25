//
//  URLSessionClient.swift
//  HttpRequest
//
//  Created by 김기현 on 2020/02/21.
//  Copyright © 2020 wimes. All rights reserved.
//

import Foundation

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol RequestProtocol {
    var session: URLSession { get set }
    var request: URLRequest { get set }
    
    init(url: URL, method: HTTPMethod, header: [String : String], body: NSMutableDictionary?)
    init(url: URL, method: HTTPMethod)
    func setHeader(header: [String: String]) -> RequestProtocol
    func setBody(body: [String: Any]) -> RequestProtocol
    func build(completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class Request: RequestProtocol{
    var session: URLSession = URLSession.shared
    var request: URLRequest
    
    required init(url: URL, method: HTTPMethod, header: [String : String], body: NSMutableDictionary? = nil) {
        //url
        self.request = URLRequest(url: url)

        //method
        self.request.httpMethod = method.rawValue

        //header
        for (key, value) in header{
            self.request.addValue(key, forHTTPHeaderField: value)
        }

        //body
        //body에 값이 있으면 실행
        if let body = body{
            do{
                self.request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            }catch{
                print(error)
            }
        }
    }
    
    required init(url: URL, method: HTTPMethod) {
        //url
        self.request = URLRequest(url: url)

        //method
        self.request.httpMethod = method.rawValue
    }
    
    func setHeader(header: [String : String]) -> RequestProtocol {
        //header
        for (key, value) in header{
            self.request.addValue(key, forHTTPHeaderField: value)
        }
        
        return self
    }
    
    func setBody(body: [String: Any] = [:]) -> RequestProtocol{
        //body
        do{
            let json = try JSONSerialization.data(withJSONObject: body, options: [])
            
            print("json:\n\(try JSONSerialization.jsonObject(with: json, options: []))")
            self.request.httpBody = json
        }catch{
            print(error)
        }
        
        return self
    }
    
    func build(completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void){
        self.session.dataTask(with: self.request, completionHandler: completionHanlder).resume()
        
    }
}
