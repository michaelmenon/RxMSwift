//
//  RxMObsrver.swift
//  RxM
//
//  Created by Midhun on 4/7/19.
// 
//

import Foundation

public protocol RxMOberverType {
    associatedtype sourceType
    
    //next event
    func on(_ next:MEvent<sourceType>)
}

extension RxMOberverType{
    
    public func onNext(_ element:sourceType){
        self.on(MEvent.next(element))
    }
    
    public func onError(_ error: Swift.Error) {
        self.on(MEvent.error(error))
    }
}

extension RxMOberverType{
    //collection of observers
   public typealias m = RxMBag<(MEvent<sourceType>)->Void>
    
    
}
