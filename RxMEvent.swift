//
//  RxMEvent.swift
//  RxM
//
//  Created by Midhun on 4/7/19.
//  
//

import Foundation

public enum RxMError:Error{
    case Empty
    case InvalidValue
    case NetworkError
    case Completed
    case InvalidUrl
}


public enum MEvent<Element>{
    case next(Element)
    case error(Swift.Error)
    
    public init(_ val:Element?=nil, error err:Swift.Error?=nil){
        
        if let c = val{
            self = .next(c)
        }else if let c = err {
            self = .error(c)
        }
        else { self = .error(RxMError.Empty)}
    }
    
    public func element() -> Element?{
        
        switch self {
        case .next(let c):
            return c
        default:
            return nil
        }
    }
    
    
   
}

extension MEvent{
    
    public func map<R>(_ transform:(Element) throws -> R ) -> MEvent<R>{
        do {
            switch self {
            case .next(let c):
                return try MEvent<R>(transform(c))
            case .error(let e):
                return MEvent<R>(error:e)
                
            }
        } catch let err {
            return MEvent<R>(error:err)
        }
        
    }
}

