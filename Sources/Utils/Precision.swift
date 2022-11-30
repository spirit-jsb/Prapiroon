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
  
  /// Offset to order signed double float numbers lexicographically.
  private static let signMask: UInt64 = 0x8000000000000000
  
  /// Positive zero double float numbers bit pattern.
  private static let positiveZeroDoubleBits: Int64 = .init(bitPattern: Double(+0.0).bitPattern)
  /// Negative zero double float numbers bit pattern.
  private static let negativeZeroDoubleBits: Int64 = .init(bitPattern: Double(-0.0).bitPattern)
  
  /// Compares two numbers given some amount of allowed error.
  ///
  /// - Parameters:
  ///   - x: the first number
  ///   - y: the second number
  ///   - epsilon: the amount of error to allow when checking for equality
  ///
  /// - Returns: 0 if equals(x: x, y: y, epsilon: epsilon); <0 if !equals(x: x, y: y, epsilon: epsilon) && x < y; >0 if !equals(x: x, y: y, epsilon: epsilon) && x > y or either argument is NaN
  internal static func compare(to x: Double, y: Double, epsilon: Double) -> Int {
    return Precision.equals(x: x, y: y, epsilon: epsilon) ? 0 : x < y ? -1 : 1
  }
  
  /// Compares two numbers given some amount of allowed
  ///
  /// - Note: Compares two numbers given some amount of allowed error.
  ///
  /// Two float numbers are considered equal if there are (maxUlps - 1) (or fewer) floating point numbers between them, i.e. two adjacent floating point numbers are considered equal.
  ///
  /// Adapted from [Bruce Dawson](http://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/).
  ///
  /// - Parameters:
  ///   - x: first value
  ///   - y: second value
  ///   - maxUlps: (maxUlps - 1) is the number of floating point values between x and y.
  ///
  /// - Returns:  0 if equals(x: x, y: y, maxUlps: maxUlps);  <0 if !equals(x: x, y: y, maxUlps: maxUlps) && x < y; >0 if !equals(x: x, y: y, maxUlps: maxUlps) && x > y or either argument is NaN
  internal static func compare(to x: Double, y: Double, maxUlps: Int) -> Int {
    return Precision.equals(x: x, y: y, maxUlps: maxUlps) ? 0 : x < y ? -1 : 1
  }
  
  /// Returns true if they are equal as defined by equals(x: x, y: y, epsilon: 1).
  ///
  /// - Parameters:
  ///   - x: first value
  ///   - y: second value
  ///
  /// - Returns: true if the values are equal.
  internal static func equals(x: Double, y: Double) -> Bool {
    return Precision.equals(x: x, y: y, epsilon: 1)
  }
  
  /// Returns true if there is no double value strictly between the arguments or the difference between them is within the range of allowed error (inclusive).
  /// Returns false if either of the arguments is NaN.
  ///
  /// - Parameters:
  ///   - x: first value.
  ///   - y: second value.
  ///   - epsilon: amount of allowed absolute error.
  ///
  /// - Returns: true if the values are two adjacent floating point numbers or they are within range of each other.
  internal static func equals(x: Double, y: Double, epsilon: Double) -> Bool {
    return Precision.equals(x: x, y: y, maxUlps: 1) || abs(y - x) <= epsilon
  }
  
  /// Returns true if the arguments are equal or within the range of allowed error (inclusive).
  ///
  /// - Note: Two float numbers are considered equal if there are (maxUlps - 1) (or fewer) floating point numbers between them, i.e. two adjacent floating point numbers are considered equal.
  ///
  /// Adapted from [Bruce Dawson]("http://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition). Returns false if either of the arguments is NaN.
  ///
  /// - Parameters:
  ///   - x: first value
  ///   - y: second value
  ///   - maxUlps: (maxUlps - 1) is the number of floating point values between x and y.
  ///
  /// - Returns: true if there are fewer than maxUlps floating point values between x and y.
  internal static func equals(x: Double, y: Double, maxUlps: Int) -> Bool {
    let xDoubleBits: Int64 = .init(bitPattern: x.bitPattern)
    let yDoubleBits: Int64 = .init(bitPattern: y.bitPattern)
    
    var isEquals: Bool
    if (xDoubleBits ^ yDoubleBits) & Int64(bitPattern: Precision.signMask) == 0 {
      // number have same sign, there is no risk of overflow
      isEquals = abs(xDoubleBits - yDoubleBits) <= maxUlps
    }
    else {
      // number have opposite signs, take care of overflow
      let deltaPlus: Int64
      let deltaMinus: Int64
      
      if xDoubleBits < yDoubleBits {
        deltaPlus = yDoubleBits - Precision.positiveZeroDoubleBits
        deltaMinus = xDoubleBits - Precision.negativeZeroDoubleBits
      }
      else {
        deltaPlus = xDoubleBits - Precision.positiveZeroDoubleBits
        deltaMinus = yDoubleBits - Precision.negativeZeroDoubleBits
      }
      
      isEquals = deltaPlus > maxUlps ? false : deltaMinus <= (Int64(maxUlps) - deltaPlus)
    }
    
    return isEquals && !x.isNaN && !y.isNaN
  }
}

#endif
