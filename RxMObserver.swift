//
//  RxMObserver.swift
//  RxM
//
//  Created by Midhun on 4/8/19.
//  
//

import Foundation

public class RxMObserver<Element>:RxMOberverType{
    
  public typealias E = Element
    
    
   public typealias EventHandler = (MEvent<Element>)->Void
   
    
   public let observer:EventHandler
    
    
    public init(eventHandler:@escaping EventHandler) {
        
        self.observer = eventHandler
            
    }
    
    
    public func on(_ next: MEvent<Element>) -> Void {
        
            self.observer(next)
    }



}

extension RxMObserver{
    
    public func mapObserver<R>(_ transform:@escaping (R)->E) -> RxMObserver<R>{
        
        let cl:(MEvent<R>)->Void = {e in
            let m:MEvent<E> = e.map(transform)
            self.on(m)
        }
        return RxMObserver<R>(eventHandler:cl)
    }
}
