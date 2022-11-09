//
//  Precision.swift
//  Prapiroon
//
//  Created by Max on 2022/11/8.
//
//  Based on https://commons.apache.org/proper/commons-math/javadocs/api-3.6.1/src-html/org/apache/commons/math3/util/Precision.html

#if canImport(Foundation)

import Foundation

/// Utilities for comparing numbers.
internal struct Precision {
  
  private static let sgnMask: UInt64 = 0x8000000000000000
  
  private static let positiveZeroDoubleBits = Double.doubleToRawLongBits(+0.0)
  private static let negativeZeroDoubleBits = Double.doubleToRawLongBits(-0.0)
  
  internal static func equals(_ x: Double, y: Double) -> Bool {
    return Precision.equals(x, y: y, epsilon: 1)
  }
  
  internal static func equals(_ x: Double, y: Double, epsilon: Double) -> Bool {
    return Precision.equals(x, y: y, maxUlps: 1) || abs(y - x) <= epsilon
  }
  
  internal static func equals(_ x: Double, y: Double, maxUlps: Int) -> Bool {
    let xBit = Double.doubleToRawLongBits(x)
    let yBit = Double.doubleToRawLongBits(y)
        
    var isEquals: Bool
    if ((xBit ^ yBit) & Int64(truncatingIfNeeded: Precision.sgnMask)) == 0 {
      // number have same sign, there is no risk of overflow
      isEquals = abs(xBit - yBit) <= maxUlps
    }
    else {
      // number have opposite signs, take care of overflow
      let deltaPlus: Int64
      let deltaMinus: Int64
      
      if xBit < yBit {
        deltaPlus = yBit - Precision.positiveZeroDoubleBits
        deltaMinus = xBit - Precision.negativeZeroDoubleBits
      }
      else {
        deltaPlus = xBit - Precision.positiveZeroDoubleBits
        deltaMinus = yBit - Precision.negativeZeroDoubleBits
      }
      
      isEquals = deltaPlus > maxUlps ? false : deltaMinus <= (Int64(truncatingIfNeeded: maxUlps) - deltaPlus)
    }
    
    return isEquals && !x.isNaN && !y.isNaN
  }
}

#endif
