//
//  ContentViewModel.swift
//  HttpRequest
//
//  Created by Gihyun Kim on 2020/02/23.
//  Copyright © 2020 wimes. All rights reserved.
//

import Foundation
import WebKit

class ContentViewModel: ObservableObject{
    let apiClient: APIClient = APIClient()
    
    var dict: [String:Any] = [String:Any]()
}

extension ContentViewModel{
    
//    func request(){
//        print("request")
//        let url: URL = URL(string: "\(Config.baseURL)/get")!
//        self.apiClient.get(url: url)
//            .onSuccess { data in
//                if let jsonString = String(data: data, encoding: .utf8){
//                    if let dict = jsonStringToDictionary(jsonString: jsonString){
//                        print(dict)
//                        self.dict = dict
//                        print(self.dict)
//                        //doSomething
//                    }
//                }
//        }
//        .onFailure { error in
//            print("wimesApp: \(error.localizedDescription)")
//        }
//    }
    
    //using promise
    func startApp_promise(){
        print("startApp_promise")
        
        let loginURL: URL = URL(string: "\(Config.baseURL)/user/logIn")!
        let articlesURL: URL = URL(string: "\(Config.baseURL)/article/articles")!
        
        let loginBody: NSMutableDictionary = NSMutableDictionary()
        loginBody["email"] = "test@gmail.com"
        loginBody["password"] = "test"
        print(loginBody)
        
//        let body: NSMutableDictionary = NSMutableDictionary()
//        body["u_id"] = 1
//        self.apiClient.post(url: articlesURL, body: body)
//            .onSuccess { data in
//                if
//        }
        
//        //login 시도
        self.apiClient.post(url: loginURL, body: loginBody)
            //login 성공시
            .then{ loginData -> Promise<Data> in
                print("login success")
                let articleBody: NSMutableDictionary = NSMutableDictionary()

                if let jsonString = String(data: loginData, encoding: .utf8){
                    if let dict = jsonStringToDictionary(jsonString: jsonString){
                        articleBody["u_id"] = dict["id"]
                    }
                }
                print(articleBody)
                //article을 받아오기 시전
                return self.apiClient.post(url: articlesURL, body: articleBody)
            }
            //article 받기 성공
            .onSuccess { data in
                print("article success")
                //출력
                if let jsonString = String(data: data, encoding: .utf8){
                    if let dict = jsonStringToDictionary(jsonString: jsonString){
                        print(dict)
                    }
                }
            }
            .onFailure { error in
                print(error)
            }
        
    }
    
    //using dispatchQueue
    func startApp_() {
        
    }
}
