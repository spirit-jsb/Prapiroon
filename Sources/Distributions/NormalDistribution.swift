//
//  NormalDistribution.swift
//  Prapiroon
//
//  Created by Max on 2022/11/7.
//
//  Based on https://commons.apache.org/proper/commons-math/javadocs/api-3.6.1/src-html/org/apache/commons/math3/distribution/NormalDistribution.html

#if canImport(Foundation)

import Foundation

/// Implementation of the normal (gaussian) distribution.
///
/// - See: [Normal distribution (Wikipedia)](http://en.wikipedia.org/wiki/Normal_distribution)
/// - See: [Normal distribution (MathWorld)](http://mathworld.wolfram.com/NormalDistribution.html)
public class NormalDistribution: AbstractRealDistribution {
  
  internal override var solverAbsoluteAccuracy: Double {
    return self._solverAbsoluteAccuracy
  }
  
  internal override var numericalMean: Double {
    return self.mean
  }
  
  internal var numericalVariance: Double {
    let standardDeviation = self.standardDeviation
    
    return standardDeviation * standardDeviation
  }
  
  internal var supportLowerBound: Double {
    return -Double.infinity
  }
  
  internal var supportUpperBound: Double {
    return Double.infinity
  }
  
  /// Mean of this distribution.
  internal private(set) var mean: Double
  /// Standard deviation of this distribution.
  internal private(set) var standardDeviation: Double
  
  /// Default inverse cumulative probability accuracy.
  private static let defaultInverseCumulativeAccuracy: Double = 1e-9
  private static let SQRT2 = sqrt(2.0)
  
  /// The value of log(sd) + 0.5 * log(2 * pi) stored for faster computation.
  private var _logStandardDeviationPlusHalfLog2Pi: Double
  /// Inverse cumulative probability accuracy.
  private var _solverAbsoluteAccuracy: Double
  
  /// Create a normal distribution with mean equal to zero and standard
  /// deviation equal to one.
  public convenience override init() {
    try! self.init(mean: 0.0, standardDeviation: 1.0)
  }
  
  /// Create a normal distribution using the given mean and standard deviation.
  ///
  /// - Parameters:
  ///   - mean: Mean for this distribution.
  ///   - standardDeviation: Standard deviation for this distribution.
  /// - Throws: PrapiroonError.NotStrictlyPositive
  public convenience init(mean: Double, standardDeviation: Double) throws {
    try self.init(mean: mean, standardDeviation: standardDeviation, inverseCumulativeAccuracy: NormalDistribution.defaultInverseCumulativeAccuracy)
  }
  
  /// Creates a normal distribution.
  ///
  /// - Parameters:
  ///   - mean: Mean for this distribution.
  ///   - standardDeviation: Standard deviation for this distribution.
  ///   - inverseCumulativeAccuracy: Inverse cumulative probability accuracy.
  /// - Throws: PrapiroonError.NotStrictlyPositive
  public init(mean: Double, standardDeviation: Double, inverseCumulativeAccuracy: Double) throws {
    guard standardDeviation > 0 else {
      throw PrapiroonError.NotStrictlyPositive.standardDeviation(standardDeviation)
    }
    
    self.mean = mean
    self.standardDeviation = standardDeviation
    
    self._logStandardDeviationPlusHalfLog2Pi = log(standardDeviation) + 0.5 * log(2.0 * .pi)
    self._solverAbsoluteAccuracy = inverseCumulativeAccuracy
  }
  
  public override func probability(_ x0: Double, x1: Double) throws -> Double {
    guard x0 <= x1 else {
      fatalError()
    }
    
    let denom = self.standardDeviation * NormalDistribution.SQRT2
    
    let v0 = (x0 - self.mean) / denom
    let v1 = (x1 - self.mean) / denom
    
    let erf = try Erf.erf(v0, x2: v1)
    
    return 0.5 * erf
  }
  
  public override func inverseCumulativeProbability(_ p: Double) throws -> Double {
    guard p >= 0.0 && p <= 1.0 else {
      throw PrapiroonError.outOfRange(p, lowerBound: 0.0, higherBound: 1.0)
    }
    
    let erfInv = try Erf.erfInv(2 * p - 1)
    
    return self.mean + self.standardDeviation * NormalDistribution.SQRT2 * erfInv
  }
  
  public override func logDensity(_ x: Double) -> Double {
    let x0 = x - self.mean
    let x1 = x0 / self.standardDeviation
    
    return -0.5 * x1 * x1 - self._logStandardDeviationPlusHalfLog2Pi
  }
  
  public func density(_ x: Double) -> Double {
    return exp(self.logDensity(x))
  }
  
  public func cumulativeProbability(_ x: Double) throws -> Double {
    let dev = x - self.mean
    
    let erfc = try Erf.erfc(-dev / (self.standardDeviation * NormalDistribution.SQRT2))
    
    return abs(dev) > 40.0 * self.standardDeviation ? dev < 0.0 ? 0.0 : 1.0 : 0.5 * erfc
  }
}

#endif
