//
//  RxMObservableType.swift
//  RxM
//
//  Created by Midhun on 4/8/19.
//  
//

import Foundation

public protocol RxMObservableType{
    associatedtype Element

    
    func subscribe<O: RxMOberverType>(_ observer: O)  where O.sourceType == Element
    
    
}
extension RxMObservableType {
    public func subscribe(_ on: @escaping (MEvent<Self.Element>)->Void){
        let c = RxMObserver(eventHandler: on)
        
        subscribe(c)
    }
   
    
}
