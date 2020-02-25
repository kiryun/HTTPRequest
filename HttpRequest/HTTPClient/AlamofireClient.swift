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
    
    func get(completionHandler: @escaping (Result<[UserData], AFError>)->Void){
        self.request = AF.request("\(Config.baseURL)/posts")
        self.request?.responseDecodable(completionHandler: { (res: DataResponse<[UserData], AFError>) in
            switch res.result{
            case .success(let userDatas):
                completionHandler(.success(userDatas))
            case .failure(let err):
                completionHandler(.failure(err))
            }
        })
    }
    
    func get2(completionHandler: @escaping (AFDataResponse<Data>) -> Void){
        let param: Parameters = ["userId": 1]
        self.request = AF.request("\(Config.baseURL)/posts", method: .get, parameters: param, encoding: URLEncoding.default)
        self.request?.responseData(completionHandler: completionHandler)
    }
    
    func post(completionHandler: @escaping (Result<[UserData], AFError>) -> Void){
        let userData = PostUserData()
        self.request = AF.request("\(Config.baseURL)/posts", method: .post, parameters: userData)
        self.request?.responseDecodable(completionHandler: { (res: DataResponse<PostUserData, AFError>) in
            switch res.result{
            case .success(let userData):
                completionHandler(.success([userData.toUserData()]))
            case .failure(let err):
                completionHandler(.failure(err))
            }
        })
    }
    
    func put(completionHandler: @escaping (Result<[UserData], AFError>) -> Void){
        let userData = PostUserData(id: 1)
        self.request = AF.request("\(Config.baseURL)/posts/1", method: .put, parameters: userData)
        self.request?.responseDecodable(completionHandler: { (res: DataResponse<PostUserData, AFError>) in
            switch res.result{
            case .success(let userData):
                completionHandler(.success([userData.toUserData()]))
            case .failure(let err):
                completionHandler(.failure(err))
            }
        })
    }
    
    func patch(completionHandler: @escaping (Result<[UserData], AFError>) -> Void){
        let userData = PostUserData(id: 1)
        self.request = AF.request("\(Config.baseURL)/posts/1", method: .patch, parameters: userData)
        self.request?.responseDecodable(completionHandler: { (res: DataResponse<PatchUserData, AFError>) in
            switch res.result{
            case .success(let userData):
                completionHandler(.success([userData.toUserData()]))
            case .failure(let err):
                completionHandler(.failure(err))
            }
        })
        
    }
    
    func delete(completionHandler: @escaping (Result<[UserData], AFError>) -> Void){
        self.request = AF.request("\(Config.baseURL)/posts/1", method: .delete)
        self.request?.response(completionHandler: { res in
            switch res.result{
            case .success:
                completionHandler(.success([UserData(userId: -1, id: -1, title: "DELETE", body: "SUCCESS")]))
            case .failure(let err):
                completionHandler(.failure(err))
            }
        })
        
    }
    
}
