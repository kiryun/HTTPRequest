//
//  ContentView.swift
//  HttpRequest
//
//  Created by 김기현 on 2020/02/21.
//  Copyright © 2020 wimes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        List{
            Button(action: self.request){
                Text("startApp_promise")
            }
            
        }
    }
}

extension ContentView{
    
    func request(){
        self.viewModel.startApp_promise()
    }
}
