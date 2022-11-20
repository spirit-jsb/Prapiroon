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
  /// - Parameters:
  ///   - n: the coefficient index to retrieve.
  ///   - x: the evaluation point.
  ///
  /// - Returns: the n-th a coefficient.
  internal var getA: (Int, Double) -> Double
  
  /// Access the n-th b coefficient of the continued fraction.
  /// Since a can be a function of the evaluation point, x, that is passed in as well.
  ///
  /// - Parameters:
  ///   - n: the coefficient index to retrieve.
  ///   - x: the evaluation point.
  ///
  /// - Returns: the n-th b coefficient.
  internal var getB: (Int, Double) -> Double
  
  /// Maximum allowed numerical error
  private static let defaultEpsilon: Double = 10e-9
  
  /// Evaluates the continued fraction at the value x.
  ///
  /// - Parameter x: the evaluation point.
  ///
  /// - Returns: the value of the continued fraction evaluated at x.
  ///
  /// - Throws: PrapiroonError.convergence, PrapiroonError.maxCountExceeded
  internal func evaluate(x: Double) throws -> Double {
    return try self.evaluate(x: x, epsilon: ContinuedFraction.defaultEpsilon, maxIterations: Int.max)
  }
  
  /// Evaluates the continued fraction at the value x.
  ///
  /// - Parameters:
  ///   - x: the evaluation point.
  ///   - epsilon: maximum error allowed.
  ///
  /// - Returns: the value of the continued fraction evaluated at x.
  ///
  /// - Throws: PrapiroonError.convergence, PrapiroonError.maxCountExceeded
  internal func evaluate(x: Double, epsilon: Double) throws -> Double {
    return try evaluate(x: x, epsilon: epsilon, maxIterations: Int.max)
  }
  
  /// Evaluates the continued fraction at the value x.
  ///
  /// - Parameters:
  ///   - x: the evaluation point.
  ///   - maxIterations: maximum number of convergents
  ///
  /// - Returns: the value of the continued fraction evaluated at x.
  ///
  /// - Throws: PrapiroonError.convergence, PrapiroonError.maxCountExceeded
  internal func evaluate(x: Double, maxIterations: Int) throws -> Double {
    return try evaluate(x: x, epsilon: ContinuedFraction.defaultEpsilon, maxIterations: maxIterations)
  }
  
  /// Evaluates the continued fraction at the value x.
  ///
  /// - Note: The implementation of this method is based on the modified Lentz algorithm as described on page 18 ff. in: [I. J. Thompson, A. R. Barnett. "Coulomb and Bessel Functions of Complex Arguments and Order."](http://www.fresco.org.uk/papers/Thompson-JCP64p490.pdf)
  /// - Note: The implementation uses the terms ai and bi as defined in [Continued Fraction @ MathWorld](http://mathworld.wolfram.com/ContinuedFraction.html)
  ///
  /// - Parameters:
  ///   - x: the evaluation point.
  ///   - epsilon: maximum error allowed.
  ///   - maxIterations: maximum number of convergents
  ///
  /// - Returns: the value of the continued fraction evaluated at x.
  ///
  /// - Throws: PrapiroonError.convergence, PrapiroonError.maxCountExceeded
  internal func evaluate(x: Double, epsilon: Double, maxIterations: Int) throws -> Double {
    let small: Double = 1e-50
    
    var hPrev = getB(0, x)
    // use the value of small as epsilon criteria for zero checks
    if Precision.equals(x: hPrev, y: 0.0, epsilon: small) {
      hPrev = small
    }
    
    var dPrev: Double = 0.0
    var cPrev = hPrev
    
    var n: Int = 1
    
    var hN = hPrev
    
    while n < maxIterations {
      let aN = getA(n, x)
      let bN = getB(n, x)
      
      var dN = bN + aN * dPrev
      if Precision.equals(x: dN, y: 0.0, epsilon: small) {
        dN = small
      }
      
      var cN = bN + aN / cPrev
      if Precision.equals(x: cN, y: 0.0, epsilon: small) {
        cN = small
      }
      
      dN = 1.0 / dN
      
      let deltaN: Double = dN * cN
      hN = hPrev * deltaN
      
      guard !hN.isInfinite else {
        throw PrapiroonError.convergence(format: "Continued fraction convergents diverged to +/- infinity for value %@", arguments: [NSNumber(value: x)])
      }
      
      guard !hN.isNaN else {
        throw PrapiroonError.convergence(format: "Continued fraction diverged to NaN for value %@", arguments: [NSNumber(value: x)])
      }
      
      guard abs(deltaN - 1.0) >= epsilon else {
        break
      }
      
      hPrev = hN
      
      dPrev = dN
      cPrev = cN
      
      n += 1
    }
    
    guard n < maxIterations else {
      throw PrapiroonError.maxCountExceeded(format: "Continued fraction convergents failed to converge (in less than %@ iterations) for value %@", maximum: NSNumber(value: maxIterations), arguments: [NSNumber(value: x)])
    }
    
    return hN
  }
}

#endif
