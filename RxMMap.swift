//
//  RxMMap.swift
//  RxM
//
//  Created by Midhun on 4/9/19.
//  
//

import Foundation

public class RxMap<sourceType , resultType>:RxMOberverType,RxMObservableType  {
    public typealias Element = resultType
    
    
    public typealias Transform = (sourceType) throws  ->  resultType
    
    
    public var _source = RxMObserver<resultType>{ (val:MEvent<resultType>) -> Void in
        
    }
        
    public let _transform: Transform
    
    
    public init( transform:  @escaping  Transform ) {
        
        self._transform = transform
        
    }
    
    public func on(_ next:MEvent<sourceType>){
        let event = next.map(_transform)
        _source.on(event)
        
    }
    
    public func subscribe<O:RxMOberverType>(_ obs: O) where O.sourceType == resultType {
        self._source = obs as! RxMObserver<resultType>
    }
        
}
