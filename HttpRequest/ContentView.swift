//
//  ContentView.swift
//  HttpRequest
//
//  Created by 김기현 on 2020/02/21.
//  Copyright © 2020 wimes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        Button(action: self.urlcall){
            Text("call")
        }
    }
    
    func urlcall(){
        let google: URL = URL(string: "https://google.com")!
        let post: URL = URL(string: "https://httpbin.org/post")!
//        // URLSession
//        let request: Request = Request()
//        let body: NSMutableDictionary = NSMutableDictionary()
//
//        try request.get(url: url, completionHandler: { data, response, error in
//            if error == nil{
//                print(data!)
//                print(response!)
//            }else{
//                print("error!")
//            }
//
//        })
        
        // URLSession with design pattern
        var header: Dictionary<String, String> = Dictionary<String, String>()
        header["application/json"] = "Content-Type"
        
        //get
        Request(url: google, method: .get)
            .setHeader(header: header)
            .build(completionHanlder: { (data, res, err) in
                if err == nil{
                    print("data: \(data!)")
                    print("response: \(res!)")
                }else{
                    print(err!)
                }
            })
        
        //post
        header["application/json"] = "Accept"
        var body: [String: Any] = [String: Any]()
        body["name"] = "wimes"
        Request(url: post, method: .post)
            .setHeader(header: header)
            .setBody(body: body)
            .build { (data, res, err) in
                if err == nil{
                    do{

                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        print("data: \(json)")
                    }catch{
                        print(error)
                    }
                    print("response: \(res!)")
                }else{
                    print(err!)
                }
                
        }
    }
}
