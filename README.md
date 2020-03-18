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

* https://linsaeng.tistory.com/7?category=753322
* https://theswiftdev.com/swift-builder-design-pattern/
* https://stackoverflow.com/questions/41997641/how-to-make-nsurlsession-post-request-in-swift
* https://stackoverflow.com/questions/31937686/how-to-make-http-post-request-with-json-body-in-swift