# HTTPRequest
URLSession vs URLSession with Builder Pattern vs AlamoFire

## URLSession

### URLSeisson을 이용한 HTTP Req 구현

* **URLSession**

  * 핵심 코드

    ```swift
    let session: URLSession = URLSession.shared
    
    session.dataTask(with: URL, completionHandler: completionHandler).resume()
    ```

    `dataTask(with:completionHandler:)`: url 요청을 실시하고 완료시 핸드러를 호출하는 task를 작성한다.(여기서 `completionHandler`는 task가 실행된 후 실행될 것이기 때문에 탈출(escaping) closure 형태로 받아야한다.)

    `resume()`: 새로 초기화 된 작업은 일시 중단된 상태에서 시작되므로 작업을 시작하려면 이 메서드를 호출해야 한다.

  * Code

    https://github.com/kiryun/HTTPRequest/tree/ed44365aff539451ac96cae8bbb7415bbc6670b7

  * Reference

    http://www.digipine.com/index.php?mid=macios&document_srl=768

    

* **Builder 패턴을 이용한 사용**

  * Overview

    빌더 패턴는 복잡한 객체의 생성을 그 객체의 표현과 분리하여, 생성 절차는 항상 동일하되 결과는 다르게 만드는 패턴입니다.
    우리가 객체를 만들다보면 생성 당시의 많은 요소를 한번에 넣어주는 요소 하나를 일력을 받아서 생성을 하는 방식 입니다.

    HTTP request를 할 때 `method`, `header`, `body`, `url` 등을 설정할 때 그때마다 다르지만 생성절차는 항상 동일합니다.
    그래서 이번에는 URLSession과 builder pattern을 이용해 HTTP request를 구현해봤습니다.

  * 핵심 코드

    기복적으로 protocol을 정의하는 것 부터 시작합니다. protocol에는 

    `session`: URLSession
    
    `request`: URLRequest
    
    `init(url:method:)` : 필수적으로 정의해야하는 것들을 우선적으로 정의합니다.
    
    `setHeader(header: [String: String]) -> RequestProtocol` : header를 정의합니다.
    
    `setBody(body: [String: Any]) -> RequestProtocol`: body를 정의합니다.
    
    `build(completionHanlder: @escaping (Data?, URLResponse?, Error?) -> Void)` : 지금 까지 정의되었던 상태를 바탕으로 url에 요청을 합니다.

    추상화된 protocol을 실제 구현하는 `class Request: RequestProtocol` 를 정의합니다.
    이제 호출하는 쪽에서 어떻게 사용하는지 보겠습니다.

    ```swift
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
    ```

    위의 코드를 보겠습니다.
    `GET` method는 `init`, `setHandler`를 이용해 기본 요소를 설정하고 `build` 메서드를 이용해 url을 요청합니다.
    `POST`method는 `GET`메서드의 요소에 `setBody` 까지 이용해 설정하고 있습니다.

    이처럼 builder pattern을 이용하면 생성 절차도 한눈에 볼 수 있으며 코딩을 할 때 보다 직관적으로 할 수 있다는 장점이 있습니다.

## Promise

Promise를 적용했습니다.

Promise의 전반적인 내용은 [여기](https://github.com/kiryun/Promise) 를 참고하시길 바랍니다.

[Server](https://github.com/kiryun/dummy_article)는 node.js를 사용했으며 localhost:3000에서 동작합니다.

## References

<<<<<<< HEAD
* https://linsaeng.tistory.com/7?category=753322
* https://theswiftdev.com/swift-builder-design-pattern/
* https://stackoverflow.com/questions/41997641/how-to-make-nsurlsession-post-request-in-swift
* https://stackoverflow.com/questions/31937686/how-to-make-http-post-request-with-json-body-in-swift
=======
    * https://linsaeng.tistory.com/7?category=753322
    * https://theswiftdev.com/swift-builder-design-pattern/
    * https://stackoverflow.com/questions/41997641/how-to-make-nsurlsession-post-request-in-swift
    * https://stackoverflow.com/questions/31937686/how-to-make-http-post-request-with-json-body-in-swift
    
## Alamofire

### Request

가장 간단한 url 호출입니다.

```swift
func get(completionHandler: @escaping (AFDataResponse<Data?>) -> Void){
  AF.request("\(Config.baseURL)").response(completionHandler: completionHandler)
}

// ...

func get_alamofire(){
  AlamofireClient.shared.get(completionHandler: { res in
		debugPrint(res)
	})
}
```

`Alamofire.request()`는 아래와 같이 정의되어 있습니다.

```swift
open func request<Parameters: Encodable>(_ convertible: URLConvertible,
                                         method: HTTPMethod = .get,
                                         parameters: Parameters? = nil,
                                         encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
                                         headers: HTTPHeaders? = nil,
                                         interceptor: RequestInterceptor? = nil) -> DataRequest
```

위의 `request` 는 요청 마다 `RequestInterceptor`들 과 `Encodable`를 만족하는 `Parameter` 를 허용합니다.
또한 메소드 및 헤더와 같은 개별 컴포넌트의 요청을 구성할 수 있도록 [DataRequest](https://alamofire.github.io/Alamofire/Classes/DataRequest.html#/s:9Alamofire11DataRequestC12responseJSON5queue7options17completionHandlerACXDSo012OS_dispatch_F0C_So20NSJSONReadingOptionsVyAA0B8ResponseVyypAA7AFErrorOGctF)를 작성합니다.

`Alamofire.request()` 메서드의 또다른 형태입니다.

```swift
open func request(_ urlRequest: URLRequestConvertible, 
                  interceptor: RequestInterceptor? = nil) -> DataRequest
```

이 메서드는 Alamofire의 URLRequestConvertible 프로토콜을 준수하는 모든 타입의 DataRequest를 작성합니다.
이전 버전과 다른 모든 매개변수가 해당 값으로 캡슐화 되어 강력한 추상화 메서드를 만들 수 있습니다.
강력한 추상화 메서드를 만드는 방법에 대해서는 **Advanced Alamofire**를 참고 해주세요



### Request parameter & Parameter encoders

Alamofire는 `Encodable`타입의 parameter를 지원합니다.

```swift
struct Login: Encodable {
    let email: String
    let password: String
}

let login = Login(email: "test@test.test", password: "testPassword")

AF.request("https://httpbin.org/post",
           method: .post,
           parameters: login,
           encoder: JSONParameterEncoder.default).response { response in
    debugPrint(response)
}
```



### URLEncodedFormParameterEncoder

`URLEncodedFormParamterEncoder`는 값을 URL 인코딩 문자열로 인코딩하여 기존 URL  쿼리 문자열로 설정/추가하거나 http body로 설정합니다. 인코딩 대상을 설정하여 인코딩 된 문자열이 설정되는 위치를 제어할 수 있습니다.
`URLEncodedFormParameterEncoder.Destination` 에는 세가지 경우가 있습니다.

* `.methodDependent`

  인코딩 된 쿼리 문자열 결과를 .get, .head 및 .delete 요청에 대한 기존 쿼리 문자열에 적용하고 다른 HTTP 메소드의 요청에 대한 HTTP body로 설정합니다.

* `.queryString`

  인코딩 된 문자열을 요청 URL의 쿼리에 설정하거나 추가합니다.

* `.httpBody`

  인코딩 된 문자열을 URLRequest의 HTTP body로 설정합니다.



#### GET Request with URL-Encoded Parameters

```swift
let parameters = ["foo": "bar"]

// All three of these calls are equivalent
AF.request("https://httpbin.org/get", parameters: parameters) // encoding defaults to `URLEncoding.default`
AF.request("https://httpbin.org/get", parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
AF.request("https://httpbin.org/get", parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .methodDependent))

// https://httpbin.org/get?foo=bar
```



#### POST Request with URL-Encoded Parameters

```swift
let parameters: [String: [String]] = [
    "foo": ["bar"],
    "baz": ["a", "b"],
    "qux": ["x", "y", "z"]
]

// All three of these calls are equivalent
AF.request("https://httpbin.org/post", method: .post, parameters: parameters)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .httpBody))

// HTTP body: "qux[]=x&qux[]=y&qux[]=z&baz[]=a&baz[]=b&foo[]=bar"
```



#### Array Encode 설정

Alaomofire는 기본적으로 Array Parameter를 인코딩 할때 `foo[]=1&foo[]=2`형식으로 encode합니다.
`foo=1&foo=2` 와 같은 형태로 인코딩하고싶다면 `.noBrackets` 속성을 사용하면 됩니다.

```swift
let parameters: [String: [String]] = [
    "foo": ["1", "2"]
]
let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))

AF.request("https://httpbin.org/post", method: .post, prameters, encoder: encoder)
```



#### Data Encode 설정

DataEncoding에는 다음과 같은 인코딩 방법이 있습니다.

* .deferredToData

  Data의 기본적으로 지원하는 인코딩을 사용합니다.

* .base64

  데이터를 Base 64로 인코딩 된 문자열로 인코딩합니다. 디폴트로 설정되어있는 값입니다.

* .custom ((Data)-> throws-> String)

  주어진 클로저를 사용하여 데이터를 인코딩합니다.

고유 한 URLEncodedFormParameterEncoder를 작성하고 전달 된 URLEncodedFormEncoder의 초기화 프로그램에서 원하는 DataEncoding을 지정할 수 있습니다.

```swift
let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(dataEncoding: .base64))
```



#### JSONParameterEncoder

Swift의 `JSONEncoder`를 이용해 인코딩하고 결과를 `URLRequest`의 `httpBody`로 설정합니다.
http header의 "Contenty-Type" 의 디폴트 값은 "application/json"입니다.

**JSON-Encoded parameter를 이용한 POST Request**

```swift
let parameters: [String: [String]] = [
    "foo": ["bar"],
    "baz": ["a", "b"],
    "qux": ["x", "y", "z"]
]

AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.prettyPrinted)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.sortedKeys)

// HTTP body: {"baz":["a","b"],"foo":["bar"],"qux":["x","y","z"]}
```



그외 다른 인코딩 방법을 보고싶다면 [여기](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#urlencodedformparameterencoder)를 참조하시면 됩니다.



### HTTP Headers

```swift
let headers: HTTPHeaders = [
    "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
    "Accept": "application/json"
]

AF.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
    debugPrint(response)
}
```

위의 `headers`를 다음과 같은 형태로 사용해도 된다.

```swift
let headers: HTTPHeaders = [
    .authorization(username: "Username", password: "Password"),
    .accept("application/json")
]

AF.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
    debugPrint(response)
}
```



### Response Handling

Alamofire에는 기본적으로 6개의 data response handler를 가지고 있습니다.

```swift
// Response Handler - Unserialized Response
func response(queue: DispatchQueue = .main, 
              completionHandler: @escaping (AFDataResponse<Data?>) -> Void) -> Self

// Response Serializer Handler - Serialize using the passed Serializer
func response<Serializer: DataResponseSerializerProtocol>(queue: DispatchQueue = .main,
                                                          responseSerializer: Serializer,
                                                          completionHandler: @escaping (AFDataResponse<Serializer.SerializedObject>) -> Void) -> Self

// Response Data Handler - Serialized into Data
func responseData(queue: DispatchQueue = .main,
                  completionHandler: @escaping (AFDataResponse<Data>) -> Void) -> Self

// Response String Handler - Serialized into String
func responseString(queue: DispatchQueue = .main,
                    encoding: String.Encoding? = nil,
                    completionHandler: @escaping (AFDataResponse<String>) -> Void) -> Self

// Response JSON Handler - Serialized into Any Using JSONSerialization
func responseJSON(queue: DispatchQueue = .main,
                  options: JSONSerialization.ReadingOptions = .allowFragments,
                  completionHandler: @escaping (AFDataResponse<Any>) -> Void) -> Self

// Response Decodable Handler - Serialized into Decodable Type
func responseDecodable<T: Decodable>(of type: T.Type = T.self,
                                     queue: DispatchQueue = .main,
                                     decoder: DataDecoder = JSONDecoder(),
                                     completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self
```



#### Response Handler

`Response`는 응답받은 데이터를 검증하는 과정이 없습니다.
URLSsessionDelegate에서 직접 모든 정보를 전달합니다. cURL을 사용하여 요청을 실행하는 것과 같은 일을 합니다.

```swift
AF.request("https://httpbin.org/get").response { response in
    debugPrint("Response: \(response)")
}
```



#### Response Data Handler

`DataResponseSerializer`를 사용하여서버가 리턴한 데이터를 추출하고 요효성을 검증합니다.
오류가 발생하지 않고 데이터가 리턴되면 응답 결과는 `.success`, `failure` 이며 각각 data와 error를 핸들링 할 수 있습니다.

```swift
AF.request("https://httpbin.org/get").responseData { response in
    debugPrint("Response: \(response)")
}
```



Response Handler는 아래처럼 `.success`와 `.failure` 를 나눠서 동작하게 할 수 도 있습니다.

```swift
func responesData(completionHandler: @escaping (AFDataResponse<Data>) -> Void){
        struct Login: Encodable{
            let email: String
            let pssword: String
        }
        
        let login = Login(email: "test@test.test", pssword: "testPassword")
        
        AF.request("\(Config.baseURL)/post",
            method: .post,
            parameters: login,
            encoder: JSONParameterEncoder.default)
        .responseData(completionHandler: completionHandler)
    }

// ...
func responseData_alamofire(){
        AlamofireClient.shared.responseData { res in
            switch res.result{
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8){
                    if let jsonDict: [String: Any] = jsonStringToDictionary(jsonString: jsonString){
                        print(jsonDict)
                    }
                }
            case .failure(let err):
                print("err발생")
                print(err)
            }
        }
    }
```



그 외의 handler형태를 보고싶다면 [여기](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-handling)를 참고하세요

* Reference
  * https://kor45cw.tistory.com/294
  * https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md
  * https://kka7.tistory.com/98
  * https://alamofire.github.io/Alamofire/
>>>>>>> 3e27428174992699e080858d8d1848c229582aac
