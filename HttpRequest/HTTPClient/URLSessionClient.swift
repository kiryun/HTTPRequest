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
    
//    func setEncoding(encoding: ParameterEncoding = URLEncoding.default) -> RequestProtocol {
//
//
//        return self
//    }
    
    
    func build(completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void){
        self.session.dataTask(with: self.request, completionHandler: completionHanlder).resume()
        
    }
}

//class Request{
//    let session: URLSession = URLSession.shared
//
//    //GET
//    func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
//        var request: URLRequest = URLRequest(url: url)
//
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        //dataTask(with:completionHandler:): url 요청을 실시하고 완료시 핸들러를 호출하는 task를 작성한다.(여기서 completionHandler 는 closure 형태로 받아야함 콜백으로 실행될 것이기 때문)
//        //resume(): 새로 초기화 된 작업은 일시 중단된 상태에서 시작되므로 작업을 시작하려면 이 메서드를 호출해야함
//        session.dataTask(with: request, completionHandler: completionHandler).resume()
//    }
//
//    //POST
//    func post(url: URL, body: NSMutableDictionary, completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void) throws{
//        var request: URLRequest = URLRequest(url: url)
//
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//        session.dataTask(with: request, completionHandler: completionHanlder).resume()
//    }
//
//    //PUT
//    func put(url: URL, body: NSMutableDictionary, completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void) throws{
//        var request: URLRequest = URLRequest(url: url)
//
//        request.httpMethod = "PUT"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//        session.dataTask(with: request, completionHandler: completionHanlder).resume()
//    }
//
//    //patch
//    func patch(url: URL, body: NSMutableDictionary, completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
//        var request: URLRequest = URLRequest(url: url)
//
//        request.httpMethod = "PATCH"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//        session.dataTask(with: request, completionHandler: completionHanlder).resume()
//    }
//
//    //delete
//    func delete(url: URL, body: NSMutableDictionary, completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void){
//        var request: URLRequest = URLRequest(url: url)
//
//        request.httpMethod = "DELETE"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        session.dataTask(with: request, completionHandler: completionHanlder).resume()
//    }
//
//}
