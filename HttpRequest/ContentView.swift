//
//  ContentView.swift
//  HttpRequest
//
//  Created by 김기현 on 2020/02/21.
//  Copyright © 2020 wimes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let request: Request = Request()
    
    var body: some View {
        
        Button(action: self.urlcall){
            Text("call")
        }
    }
    
    func urlcall(){
        
        let url: URL = URL(string: "https://google.com")!
//        let body: NSMutableDictionary = NSMutableDictionary()
        
        try request.get(url: url, completionHandler: { data, response, error in
            if error == nil{
                print(data!)
                print(response!)
            }else{
                print("error!")
            }
            
        })
    }
}
