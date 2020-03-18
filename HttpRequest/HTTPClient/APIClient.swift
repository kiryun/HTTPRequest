//
//  APIClient.swift
//  HttpRequest
//
//  Created by Gihyun Kim on 2020/03/18.
//  Copyright © 2020 wimes. All rights reserved.
//

import Foundation

extension URLSession{
    enum HTTPError: LocalizedError{
        case invalidResponse
        case invalidStatusCode
        case noData
    }
    
    func dataTask(with: URLRequest) -> Promise<Data> {
        return Promise<Data> { [unowned self] fulfill, reject in
            self.dataTask(with: with) { data, response, error in
                if let error = error {
                    reject(error)
                    return
                }
//                print(response)
                guard let response = response as? HTTPURLResponse else {
                    print("invalidResponse")
                    reject(HTTPError.invalidResponse)
                    return
                }
//                print(response.statusCode)
//                print(response.statusCode >= 200 && response.statusCode < 300)
                guard (response.statusCode >= 200 && response.statusCode < 300) else {
                    print("invalidStatusCode")
                    reject(HTTPError.invalidStatusCode)
                    return
                }
                guard let data = data else {
                    print("noData")
                    reject(HTTPError.noData)
                    return
                }
                fulfill(data)
            }.resume()
        }
    }
    
}

class APIClient{
    let session: URLSession = URLSession.shared
    
    //GET
    func get(url: URL) -> Promise<Data>{
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //dataTask(with:completionHandler:): url 요청을 실시하고 완료시 핸들러를 호출하는 task를 작성한다.(여기서 completionHandler 는 closure 형태로 받아야함 콜백으로 실행될 것이기 때문)
        //resume(): 새로 초기화 된 작업은 일시 중단된 상태에서 시작되므로 작업을 시작하려면 이 메서드를 호출해야함
//
        return self.session.dataTask(with: request)
    }
    
    //POST
    func post(url: URL, body: NSMutableDictionary) -> Promise<Data> {
        print("APIClient.post")
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch{
            print("APIClient.post: \(error)")
        }
        
        return self.session.dataTask(with: request)
    }
    
    //PUT
    func put(url: URL, body: NSMutableDictionary, completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void) throws{
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        session.dataTask(with: request, completionHandler: completionHanlder).resume()
    }
    
    //patch
    func patch(url: URL, body: NSMutableDictionary, completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        session.dataTask(with: request, completionHandler: completionHanlder).resume()
    }
    
    //delete
    func delete(url: URL, body: NSMutableDictionary, completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void){
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request, completionHandler: completionHanlder).resume()
    }
}
