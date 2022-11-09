//
//  Double+Prapiroon.swift
//  Prapiroon
//
//  Created by Max on 2022/11/9.
//

#if canImport(Foundation)

import Foundation

internal extension Double {
  
  static func doubleToRawLongBits(_ num: Double) -> Int64 {
    var bits: Int64 = 0
    
    var newNum = num
    
    memcpy(&bits, &newNum, MemoryLayout.size(ofValue: bits))
    
    return bits
  }
}

#endif
