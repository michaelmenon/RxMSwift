//
//  RxMObservers.swift
//  RxM
//
//  Created by Midhun on 4/7/19.
//  

import Foundation

public struct BagKey {
    
    public let keyValue: UInt64
}
 extension BagKey: Hashable {
    public var hashValue: Int {
        return keyValue.hashValue
    }
}

 public func ==(lhs: BagKey, rhs: BagKey) -> Bool {
    return lhs.keyValue == rhs.keyValue
}


public class RxMBag<T>{
    
   
    public var bagKey:BagKey = BagKey(keyValue:0)
    public var bag:Dictionary = [BagKey:T]()
    
    public func insert(_ val:T) -> BagKey{
        bagKey  = BagKey(keyValue:bagKey.keyValue &+ 1)
        bag[bagKey] = val
        return bagKey
        
    }
    
    public func removeAll(){
        
        self.bag.removeAll()
    }
    
}

@inline(__always)
public func dispatch<T>(_ dBag:RxMBag<(MEvent<T>)->Void>,_ event:MEvent<T>){
    
    for handler in dBag.bag.values {
        handler(event)
    }
}
