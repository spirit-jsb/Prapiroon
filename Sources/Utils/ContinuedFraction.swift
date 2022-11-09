//
//  ContinuedFraction.swift
//  Prapiroon
//
//  Created by Max on 2022/11/8.
//
//  Based on https://commons.apache.org/proper/commons-math/javadocs/api-3.6.1/src-html/org/apache/commons/math3/util/ContinuedFraction.html

#if canImport(Foundation)

import Foundation

/// Provides a generic means to evaluate continued fractions.
/// Subclasses simply provided the a and b coefficients to evaluate the continued fraction.
///
/// - Note: [Continued Fraction](http://mathworld.wolfram.com/ContinuedFraction.html)
internal struct ContinuedFraction {
  
  /// Access the n-th a coefficient of the continued fraction.
  /// Since a can be a function of the evaluation point, x, that is passed in as well.
  ///
  /// - Parameter n: the coefficient index to retrieve.
  /// - Parameter x: the evaluation point.
  /// - Returns: the n-th a coefficient.
  internal var getA: (Int, Double) -> Double
  
  /// Access the n-th b coefficient of the continued fraction.
  /// Since a can be a function of the evaluation point, x, that is passed in as well.
  ///
  /// - Parameter n: the coefficient index to retrieve.
  /// - Parameter x: the evaluation point.
  /// - Returns: the n-th b coefficient.
  internal var getB: (Int, Double) -> Double
  
  /// Maximum allowed numerical error
  private static let defaultEpsilon: Double = 10e-9
  
  internal init(getA: @escaping (Int, Double) -> Double, getB: @escaping (Int, Double) -> Double) {
    self.getA = getA
    self.getB = getB
  }
  
  internal func evaluate(_ x: Double) throws -> Double {
    return try self.evaluate(x, epsilon: ContinuedFraction.defaultEpsilon, maxIterations: Int.max)
  }
  
  internal func evaluate(_ x: Double, epsilon: Double) throws -> Double {
    return try self.evaluate(x, epsilon: epsilon, maxIterations: Int.max)
  }
  
  internal func evaluate(_ x: Double, maxIterations: Int) throws -> Double {
    return try self.evaluate(x, epsilon: ContinuedFraction.defaultEpsilon, maxIterations: maxIterations)
  }
  
  internal func evaluate(_ x: Double, epsilon: Double, maxIterations: Int) throws -> Double {
    let small: Double = 1e-50
    
    var hPrev = getA(0, x)
    // use the value of small as epsilon criteria for zero checks
    if Precision.equals(hPrev, y: 0.0, epsilon: small) {
      hPrev = small
    }
    
    var n: Int = 1
    
    var hN = hPrev
    
    var cPrev = hPrev
    var dPrev: Double = 0.0
    
    while n < maxIterations {
      let a = getA(n, x)
      let b = getB(n, x)
      
      var cN = a + b / cPrev
      if Precision.equals(cN, y: 0.0, epsilon: small) {
        cN = small
      }
      
      var dN = a + b * dPrev
      if Precision.equals(dN, y: 0.0, epsilon: small) {
        dN = small
      }
      
      dN = 1.0 / dN
      
      let deltaN: Double = cN * dN
      hN = hPrev * deltaN
      
      if hN.isInfinite {
        // TODO: ConvergenceException
        fatalError()
      }
      
      if hN.isNaN {
        // TODO: ConvergenceException
        fatalError()
      }
      
      if abs(deltaN - 1.0) < epsilon {
        break
      }
      
      cPrev = cN
      dPrev = dN
      hPrev = hN
      
      n += 1
    }
    
    if n >= maxIterations {
      // TODO: ConvergenceException
      fatalError()
    }
    
    return hN
  }
}

#endif
