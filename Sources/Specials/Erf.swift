//
//  Erf.swift
//  Prapiroon
//
//  Created by Max on 2022/11/8.
//
//  Based on https://commons.apache.org/proper/commons-math/javadocs/api-3.6.1/src-html/org/apache/commons/math3/special/Erf.html

#if canImport(Foundation)

import Foundation

/// This is a utility class that provides computation methods related to the error functions.
internal struct Erf {
  
  /// The number X_CRIT is used by erf(_ x1: double, x2: double) internally.
  /// This number solves erf(x)=0.5 within 1ulp.
  /// More precisely, the current implementations of erf(_ x: double) and erfc(_ x: double) satisfy:
  /// erf(X_CRIT) < 0.5,
  /// erf(.nextUp(X_CRIT) > 0.5,
  /// erfc(X_CRIT) = 0.5,
  /// erfc(.nextUp(X_CRIT) < 0.5
  private static let xCrit: Double = 0.4769362762044697
  
  internal static func erf(_ x: Double) throws -> Double {
    if abs(x) > 40.0 {
      return x > 0.0 ? 1.0 : -1.0
    }
    
    let result = try Gamma.regularizedGammaP(0.5, x: x * x, epsilon: 1.0e-15, maxIterations: 10000)
    
    return x < 0.0 ? -result : result
  }
  
  internal static func erf(_ x1: Double, x2: Double) throws -> Double {
    guard x1 <= x2 else {
      return -(try Erf.erf(x2, x2: x1))
    }
    
    return x1 < -Erf.xCrit ?
    x2 < 0.0 ?
    (try Erf.erfc(-x2)) - (try Erf.erfc(-x1)) :
    (try Erf.erf(x2)) - (try Erf.erf(x1)) :
    x2 > Erf.xCrit && x1 > 0.0 ?
    (try Erf.erfc(x1)) - (try Erf.erfc(x2)) :
    (try Erf.erf(x2)) - (try Erf.erf(x1))
  }
  
  internal static func erfc(_ x: Double) throws -> Double {
    if abs(x) > 40.0 {
      return x > 0.0 ? 0.0 : 2.0
    }
    
    let result = try Gamma.regularizedGammaQ(0.5, x: x * x, epsilon: 1.0e-15, maxIterations: 10000)
    
    return x < 0.0 ? 2.0 - result : result
  }
  
  internal static func erfInv(_ x: Double) throws -> Double {
    // beware that the logarithm argument must be
    // commputed as (1.0 - x) * (1.0 + x),
    // it must NOT be simplified as 1.0 - x * x as this
    // would induce rounding errors near the boundaries +/-1
    var w: Double = -log((1.0 - x) * (1.0 + x))
    
    var p: Double
    
    if (w < 6.25) {
      w -= 3.125
      
      p = -3.6444120640178196996e-21;
      p = -1.685059138182016589e-19 + p * w
      p = 1.2858480715256400167e-18 + p * w
      p = 1.115787767802518096e-17 + p * w
      p = -1.333171662854620906e-16 + p * w
      p = 2.0972767875968561637e-17 + p * w
      p = 6.6376381343583238325e-15 + p * w
      p = -4.0545662729752068639e-14 + p * w
      p = -8.1519341976054721522e-14 + p * w
      p = 2.6335093153082322977e-12 + p * w
      p = -1.2975133253453532498e-11 + p * w
      p = -5.4154120542946279317e-11 + p * w
      p = 1.051212273321532285e-09 + p * w
      p = -4.1126339803469836976e-09 + p * w
      p = -2.9070369957882005086e-08 + p * w
      p = 4.2347877827932403518e-07 + p * w
      p = -1.3654692000834678645e-06 + p * w
      p = -1.3882523362786468719e-05 + p * w
      p = 0.0001867342080340571352 + p * w
      p = -0.00074070253416626697512 + p * w
      p = -0.0060336708714301490533 + p * w
      p = 0.24015818242558961693 + p * w
      p = 1.6536545626831027356 + p * w
    }
    else if w < 16.0 {
      w = sqrt(w) - 3.25
      
      p = 2.2137376921775787049e-09
      p = 9.0756561938885390979e-08 + p * w
      p = -2.7517406297064545428e-07 + p * w
      p = 1.8239629214389227755e-08 + p * w
      p = 1.5027403968909827627e-06 + p * w
      p = -4.013867526981545969e-06 + p * w
      p = 2.9234449089955446044e-06 + p * w
      p = 1.2475304481671778723e-05 + p * w
      p = -4.7318229009055733981e-05 + p * w
      p = 6.8284851459573175448e-05 + p * w
      p = 2.4031110387097893999e-05 + p * w
      p = -0.0003550375203628474796 + p * w
      p = 0.00095328937973738049703 + p * w
      p = -0.0016882755560235047313 + p * w
      p = 0.0024914420961078508066 + p * w
      p = -0.0037512085075692412107 + p * w
      p = 0.005370914553590063617 + p * w
      p = 1.0052589676941592334 + p * w
      p = 3.0838856104922207635 + p * w
    }
    else if !w.isInfinite {
      w = sqrt(w) - 5.0
      
      p = -2.7109920616438573243e-11
      p = -2.5556418169965252055e-10 + p * w
      p = 1.5076572693500548083e-09 + p * w
      p = -3.7894654401267369937e-09 + p * w
      p = 7.6157012080783393804e-09 + p * w
      p = -1.4960026627149240478e-08 + p * w
      p = 2.9147953450901080826e-08 + p * w
      p = -6.7711997758452339498e-08 + p * w
      p = 2.2900482228026654717e-07 + p * w
      p = -9.9298272942317002539e-07 + p * w
      p = 4.5260625972231537039e-06 + p * w
      p = -1.9681778105531670567e-05 + p * w
      p = 7.5995277030017761139e-05 + p * w
      p = -0.00021503011930044477347 + p * w
      p = -0.00013871931833623122026 + p * w
      p = 1.0103004648645343977 + p * w
      p = 4.8499064014085844221 + p * w
    }
    else {
      // this branch does not appears in the original code, it
      // was added because the previous branch does not handle
      // x = +/-1 correctly. In this case, w is positive infinity
      // and as the first coefficient (-2.71e-11) is negative.
      // Once the first multiplication is done, p becomes negative
      // infinity and remains so throughout the polynomial evaluation.
      // So the branch above incorrectly returns negative infinity
      // instead of the correct positive infinity.
      p = .infinity
    }
    
    return p * x
  }
  
  internal static func erfcInv(_ x: Double) throws -> Double {
    return try Erf.erfInv(1.0 - x)
  }
}

#endif
