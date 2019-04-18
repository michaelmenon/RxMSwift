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
        
        let cl = {[weak self,_observers] in
            
            guard self != nil else{return}
            while !self!._lock.try(){}
            dispatch(_observers, MEvent(item))
            self!._lock.unlock()
        }
        
        DispatchQueue.global().sync {
            
            cl()
        }
       
    }
    
    public func onError(_ err:Swift.Error){
       
        let cl = {[weak self,_observers] in
        
            guard self != nil else{return}
            while !self!._lock.try(){}
            let errEvent = MEvent<E>(error:err)
            dispatch(_observers, errEvent)
             self!._lock.unlock()
        }
        
        DispatchQueue.global().sync {
            
            cl()
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





