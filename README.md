# RxMSwift
Reactive style lightweight Swift framework inspired from RxSwift
It’s lightweight, just drag and drop the RxMSwift folder to any Swift native project in which you want to use it.  
 
You can have multiple listeners to listen to values and everything is asynchronous so it will not block the UI.
 

 
Features given below :
 
It has a simple class RxMPusher which you can initialize with any data type as given below :
 
let pusher:RxMPusher<String> = RxMPusher<String>()
 
and then subscribe to listen to events like this:
 
pusher.subscribe{ event in
            switch event {
                case .next(let c):
                    print(c)
                case .error(let err):
                    print(err)
                }
            
     
 
Push the values to listeners like this :
pusher.push("A")
 
You can have multiple subscribers and each subscribers will get values asynchronously so not blocking the UI.
 
Asynchronous Web API call : If you want to call a webservice API asynchronously just use the class RxMData provided:
 
let r:RxMData = RxMData()
r.start("https://jsonplaceholder.typicode.com/todos/1")
            .subscribe{ event in
            switch event {
            case .next(let c):
                print(String(decoding: c, as: UTF8.self))
            case .error(let err):
                print(err)
            }
        }
 
Mapping an event from one type to other type :
  pusher.map{ val throws ->  Int  in
                
                if val == "A"{
                    return 2
                }else if val == "B"{
                    return 3
                }else {
                    throw RxMError.Completed
                }
            }.subscribe{ event in
                switch event {
                case .next(let c):
                    print(c)
                case .error(let err):
                    print(err)
              }
            }
 
 
Push error to subscribers in case of error events :
pusher.onError(RxMError.InvalidValue)
 
