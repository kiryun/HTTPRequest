//
//  ContentView.swift
//  HttpRequest
//
//  Created by 김기현 on 2020/02/21.
//  Copyright © 2020 wimes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel = ContentViewModel()
    
    var body: some View {
        List{
//            Button(action: self.urlcall){
//                Text("call")
//            }
            Button(action: self.get){
                Text("get")
            }
            Button(action: self.get2){
                Text("get2")
            }
            Button(action: self.post){
                Text("post")
            }
            Button(action: self.put){
                Text("put")
            }
            Button(action: self.patch){
                Text("patch")
            }
            Button(action: self.delete){
                Text("delete")
            }
        }
        
    }
    
    func urlcall(){
//        self.vm.postMethod()
    }
    
    func get(){
        self.vm.get_alamofire()
    }
    
    func get2(){
        self.vm.get2_alamofire()
    }
    
    func post(){
        self.vm.post_alamofire()
        
    }
    
    func put(){
        self.vm.put_alamofire()
    }
    
    func patch(){
        self.vm.patch_alamofire()
    }
    
    func delete(){
        self.vm.delete_alamofire()
    }
}
