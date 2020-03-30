//
//  HttpRequestTests.swift
//  HttpRequestTests
//
//  Created by 김기현 on 2020/03/27.
//  Copyright © 2020 wimes. All rights reserved.
//

import XCTest
@testable import HttpRequest // Test하고자 하는 module들이 들어있는 group(폴더)를 import해줘야 함.

class UserTests: XCTestCase {
    let apiClient: APIClient = APIClient()
    var u_id: Int = -1
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // 회원가입
        let url: URL = URL(string: "\(Config.baseURL)/user/signUp")!
        let body: NSMutableDictionary = NSMutableDictionary()
        
        body["email"] = "test@test"
        body["password"] = "test"
        
//        var result = ""
        let promise = expectation(description: "Completion handler invoked")
        
        self.apiClient.post(url: url, body: body)
                    .onSuccess { data in
                        promise.fulfill()
                }

        
        //then
        waitForExpectations(timeout: 3) { err in
            if let err = err{
                XCTFail("\(err)")
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //test user 삭제
        let url: URL = URL(string: "\(Config.baseURL)/user/signOut")!
        let body: NSMutableDictionary = NSMutableDictionary()
        
        body["email"] = "test@test"
        body["password"] = "test"
        
        self.apiClient.post(url: url, body: body)
    }
    
    //sign in
    func testlogIn(){
        //given
        let expect = "test@test"
        
        //when
        let url: URL = URL(string: "\(Config.baseURL)/user/logIn")!
        let body: NSMutableDictionary = NSMutableDictionary()
        
        body["email"] = "test@test"
        body["password"] = "test"
        
        var result = ""
        let promise = expectation(description: "Completion handler invoked")
        
        self.apiClient.post(url: url, body: body)
            .onSuccess { data in
                if let jsonString = String(data: data, encoding: .utf8){
                    if let dict = jsonStringToDictionary(jsonString: jsonString){
                        self.u_id = dict["id"] as! Int
                        result = dict["email"] as! String
                    }
                }
                promise.fulfill()
        }
        waitForExpectations(timeout: 3) { err in
            if let err = err{
                XCTFail("\(err)")
            }
        }
        
        //then
        XCTAssertEqual(expect, result, "result: \(result)")
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

class ArticleTests: XCTestCase{
    let apiClient: APIClient = APIClient()
    let userTest: UserTests = UserTests()
    var u_id: Int = -1
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.userTest.setUp()
        self.userTest.testlogIn()
        self.u_id = userTest.u_id
        

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // 모든 article 다 지운다.
        let url: URL = URL(string: "\(Config.baseURL)/article/removeAll/\(self.u_id)")!
        self.apiClient.post(url: url, body: nil)
//        self.userTest.tearDown()
    }
    
    //create article
    func testCreateArticle(){
        //given
        let expect = self.u_id
        
        //when
        let url: URL = URL(string: "\(Config.baseURL)/article/create")!
        let body: NSMutableDictionary = NSMutableDictionary()
        
        print("u_id: \(self.u_id)")
        body["u_id"] = self.u_id
        body["title"] = "test"
        body["author"] = "wimes"
        body["body"] = "hello world!"
        
        var result = 0
        let promise = expectation(description: "Completion handler invoked")
        
        self.apiClient.post(url: url, body: body)
            .onSuccess { data in
                if let jsonString = String(data: data, encoding: .utf8){
                    if let dict = jsonStringToDictionary(jsonString: jsonString){
                        result = dict["u_id"] as! Int
                    }
                }
                promise.fulfill()
        }
        waitForExpectations(timeout: 3) { err in
            if let err = err{
                XCTFail("\(err)")
            }
        }
        
        //then
        XCTAssertEqual(expect, result, "result: \(result)")
        
    }
    
    //get article
    func testArticles(){
        //given
//        let expect: Int = 201
        
        //when
        let url: URL = URL(string: "\(Config.baseURL)/article/articles")!
        let body: NSMutableDictionary = NSMutableDictionary()
        
        body["u_id"] = self.u_id
        
        var result: Any?
        let promise = expectation(description: "Completion handler invoked")
        
        self.apiClient.post(url: url, body: body)
            .onSuccess { data in
                
                if let jsonString = String(data: data, encoding: .utf8){
                    if let dict = jsonStringToDictionary(jsonString: jsonString){
                        result = dict
                    }
                }
                promise.fulfill()
        }
        waitForExpectations(timeout: 3) { err in
            if let err = err{
                XCTFail("\(err)")
            }
        }
        
        //then
        XCTAssertNotNil(result)
    }
}
