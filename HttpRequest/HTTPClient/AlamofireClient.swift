//
//  AlamofireClient.swift
//  HttpRequest
//
//  Created by 김기현 on 2020/02/21.
//  Copyright © 2020 wimes. All rights reserved.
//

import Foundation
import Alamofire

//Alamofire handler
class AlamofireClient{
    static let shared: AlamofireClient = AlamofireClient()
    //request가 시도 중에 새로운 request가 생성되면, 현재 진행중인 oldValue의 request를 cancel 하고 새로운 request를 실행하도록 한다.
    private var request: DataRequest? {
        didSet{
            oldValue?.cancel()
        }
    }
    
    private init() {
        
    }
    
    func get(completionHandler: @escaping (AFDataResponse<Data?>) -> Void){
        AF.request("\(Config.baseURL)/get").response(completionHandler: completionHandler)
    }
    
    func postUsingParam(completionHandler: @escaping (AFDataResponse<Data?>) -> Void){
        struct Login: Encodable{
            let email: String
            let pssword: String
        }
        
        let login = Login(email: "test@test.test", pssword: "testPassword")
        
        AF.request("\(Config.baseURL)/post",
            method: .post,
            parameters: login,
            encoder: JSONParameterEncoder.default)
            .response(completionHandler: completionHandler)
    }
    
    
    func postJSONParam(completionHandler: @escaping (AFDataResponse<Data?>) -> Void){
        let parameters: [String: [String]] = [
            "foo": ["bar"],
            "baz": ["a", "b"],
            "qux": ["x", "y", "z"]
        ]

        //post json default
        AF.request("\(Config.baseURL)/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).response(completionHandler: completionHandler)
        
        //post json prettyPrinted
        AF.request("\(Config.baseURL)/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.prettyPrinted).response(completionHandler: completionHandler)
        
        //post json sortedKeys
        AF.request("\(Config.baseURL)/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.sortedKeys)
            .response(completionHandler: completionHandler)
        

        // HTTP body: {"baz":["a","b"],"foo":["bar"],"qux":["x","y","z"]}
    }
    
    func httpHeader(completionHandler: @escaping (AFDataResponse<Any>) -> Void){
//        let headers: HTTPHeaders = [
//            "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
//            "Accept": "application/json"
//        ]
        
        //아래와 같이 headers를 초기화해도 된다.
        let headers: HTTPHeaders = [
            .authorization(username: "Username", password: "Password"),
            .accept("application/json")
        ]
        
        AF.request("\(Config.baseURL)/headers", headers: headers).responseJSON(completionHandler: completionHandler)
        
    }
    
    
    func responseData(completionHandler: @escaping (AFDataResponse<Data>) -> Void){
        print("responseData")
//        struct Login: Encodable{
//            let email: String
//            let password: String
//        }
        let login = Login(email: "test@test.test", password: "testPassword")
        
        AF.request("\(Config.baseURL)/post",
            method: .post,
            parameters: login,
            encoder: JSONParameterEncoder.default)
        .responseData(completionHandler: completionHandler)
    }
    
    
    func get2(completionHandler: @escaping (AFDataResponse<Data>) -> Void){
        let param: Parameters = ["userId": 1]
        self.request = AF.request("\(Config.baseURL)/posts", method: .get, parameters: param, encoding: URLEncoding.default)
        self.request?.responseData(completionHandler: completionHandler)
    }
    
}
