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

    // URLSession non builder pattern
//    func getGoogle(){
//        guard let google: URL = URL(string: "https://google.com") else{
//            return
//        }
//
//        let request: Request = Request()
//        let body: NSMutableDictionary = NSMutableDictionary()
//
//        try request.get(url: google, completionHandler: { data, response, error in
//            if error == nil{
//                print(data!)
//                print(response!)
//            }else{
//                print("error!")
//            }
//        })
//    }

    // URLSession with design pattern
//    func postMethod(){
//        guard let url: URL = URL(string: "https://httpbin.org/post")else{
//            return
//        }
//
//        var header: Dictionary<String, String> = Dictionary<String, String>()
//        header["application/json"] = "Content-Type"
//
//
//        //post
//        header["application/json"] = "Accept"
//        var body: [String: Any] = [String: Any]()
//        body["name"] = "wimes"
//        Request(url: url, method: .post)
//            .setHeader(header: header)
//            .setBody(body: body)
//            .build { (data, res, err) in
//                if err == nil{
//                    do{
//
//                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                        print("data: \(json)")
//                    }catch{
//                        print(error)
//                    }
//                    print("response: \(res!)")
//                }else{
//                    print(err!)
//                }
//        }
//    }
    
    //Alamofire
    func get_alamofire(){
        AlamofireClient.shared.get(completionHandler: { res in
            switch res{
            case .success:
                print(res)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func get2_alamofire(){
        AlamofireClient.shared.get2(completionHandler: { res in
            switch res.result{
            case .success:
                do{
                    let json = try JSONSerialization.jsonObject(with: res.data!, options: [])
                    print("data: \(json)")
                }catch{
                    print(error)
                }
            case let .failure(err):
                print(err)
            }
        })
    }
    
    func post_alamofire(){
        AlamofireClient.shared.post(completionHandler: { res in
            switch res{
            case .success:
                print(res)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func put_alamofire(){
        AlamofireClient.shared.put(completionHandler: { res in
            switch res{
            case .success:
                print(res)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func patch_alamofire(){
        AlamofireClient.shared.patch(completionHandler: { res in
            switch res{
            case .success:
                print(res)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func delete_alamofire(){
        AlamofireClient.shared.delete(completionHandler: { res in
            switch res{
            case .success:
                print(res)
            case .failure(let err):
                print(err)
            }
        })
    }
}
