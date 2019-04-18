//
//  RxMData.swift
//  RxM
//
//  Created by Midhun on 4/13/19.
//  
//

import Foundation

public class RxMData{
    
    public var pusher = RxMPusher<Data>()
    
    public init(){}
    
    public func start(_ source:String ) -> RxMPusher<Data> {
        
        DispatchQueue.global().async {[weak self] in
            guard let c = URL(string: source) else{
                
                self!.pusher.onError(RxMError.InvalidUrl)
                return
            }
            let request = URLRequest(url:c)
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                        
                if error == nil,let usableData = data {
                    self!.pusher.push(usableData)
                }
                else{
                    self!.pusher.onError(error!)
                }
    
            }
            task.resume()
        }
        return  pusher
    
    }
    
        
    
}


