//
//  RxMPusher.swift
//  RxM
//
//  Created by Midhun on 4/8/19.
//  
//

import Foundation

public class RxMPusher<E>:RxMObservableType{
    
    public typealias Element = E
   
    
    fileprivate let _lock = NSRecursiveLock()
    
    public var _observers = RxMObserver<E>.m()
   
    public init(){}
    
    public func subscribe<O:RxMOberverType>(_ obs: O) where O.sourceType == E{
        while !_lock.try(){}
        defer {
            _lock.unlock()
        }
        _observers.insert(obs.on)
        
    }
    
    public func push(_ item:E){
        
            DispatchQueue.global().async {[weak self] in
                
                guard self != nil else{return}
                while !self!._lock.try(){}
                defer {
                    self!._lock.unlock()
                }
                dispatch(self!._observers, MEvent(item))
               
                
            }
    }
    
    public func onError(_ err:Swift.Error){
        let errEvent = MEvent<E>(error:err)
        DispatchQueue.global().async {[weak self] in
            
            guard self != nil else{return}
            while !self!._lock.try(){}
            defer {
                self!._lock.unlock()
            }
            dispatch(self!._observers, errEvent)
            
            
        }
        
    }
    
    public func map<R>(_ transform:@escaping (E )throws-> R ) -> RxMap<E,R>{
        
       // let s = RxMObserver(eventHandler:transform)
        let m = RxMap<E,R>(transform: transform)
        
        let O:(MEvent<E>)->Void = {(val:MEvent<E>) in
            
            m.on(val)
        }
        self.subscribe(O)
        return m
        
        
    }
   
    
    public func dispose(){
        if _lock.try(){
            defer {
                _lock.unlock()
            }
            _observers.removeAll()
        }
    }
    
   
    
}


