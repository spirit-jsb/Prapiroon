//
//  AbstractRealDistribution.swift
//  Prapiroon
//
//  Created by Max on 2022/11/7.
//
//  Based on https://commons.apache.org/proper/commons-math/javadocs/api-3.6.1/src-html/org/apache/commons/math3/distribution/AbstractRealDistribution.html

#if canImport(Foundation)

import Foundation

/// Base class for probability distributions on the reals.
///
/// Default implementations are provided for some of the methods
/// that do not vary from distribution to distribution.
public class AbstractRealDistribution: RealDistribution {
  
  /// Solver absolute accuracy for inverse cumulative computation
  internal private(set) var solverAbsoluteAccuracy: Double = 1e-6
  
  internal private(set) var numericalMean: Double = 0.0
  
  internal func probability(_ x0: Double, x1: Double) throws -> Double {
    guard x0 <= x1 else {
      fatalError()
    }
    
    return self.cumulativeProbability(x1) - self.cumulativeProbability(x0)
  }
  
  /// - Returns: zero
  internal func probability(_ x: Double) -> Double {
    return 0.0
  }
  
  /// - Note: Where applicable, use is made of the one-sided Chebyshev inequality to bracket the root.
  ///
  /// This inequality states that
  /// P(X - mu >= k * sig) <= 1 / (1 + k^2),
  /// mu: mean, sig: standard deviation.
  /// Equivalently 1 - P(X < mu + k * sig) <= 1 / (1 + k^2), F(mu + k * sig) >= k^2 / (1 + k^2).
  ///
  /// For k = sqrt(p / (1 - p)), we find
  /// F(mu + k * sig) >= p, and (mu + k * sig) is an upper-bound for the root.
  ///
  /// Then, introducing Y = -X, mean(Y) = -mu, sd(Y) = sig, and
  /// P(Y >= -mu + k * sig) <= 1 / (1 + k^2),
  /// P(-X >= -mu + k * sig) <= 1 / (1 + k^2),
  /// P(X <= mu - k * sig) <= 1 / (1 + k^2),
  /// F(mu - k * sig) <= 1 / (1 + k^2).
  ///
  /// For k = sqrt((1 - p) / p), we find
  /// F(mu - k * sig) <= p, and (mu - k * sig) is a lower-bound for the root.
  ///
  /// In cases where the Chebyshev inequality does not apply, geometric
  /// progressions 1, 2, 4, ... and -1, -2, -4, ... are used to bracket the root.
  ///
  /// - Returns: the default implementation returns.
  ///   supportLowerBound for p = 0
  ///   supportUpperBound for p = 1
  internal func inverseCumulativeProbability(_ p: Double) throws -> Double {
    guard p >= 0.0 && p <= 1.0 else {
      throw PrapiroonError.outOfRange(wrong: NSNumber(value: p), lowerBound: NSNumber(value: 0.0), higherBound: NSNumber(value: 1.0))
    }
    
    var lowerBound = self.supportLowerBound
    if p == 0.0 {
      return lowerBound
    }
    
    var upperBound = self.supportUpperBound
    if p == 1.0 {
      return upperBound
    }
    
    let mu = self.numericalMean
    let sig = sqrt(self.numericalVariance)
    
    let chebyshevApplies = !mu.isInfinite || mu.isNaN || sig.isInfinite || sig.isNaN
    
    if lowerBound == -Double.infinity {
      if chebyshevApplies {
        lowerBound = mu - sig * sqrt((1.0 - p) / p)
      }
      else {
        lowerBound = -1.0
        
        while self.cumulativeProbability(lowerBound) >= p {
          lowerBound *= 2.0
        }
      }
    }
    
    if upperBound == Double.infinity {
      if chebyshevApplies {
        upperBound = mu + sig * sqrt(p / (1.0 - p))
      }
      else {
        upperBound = 1.0
        
        while self.cumulativeProbability(upperBound) < p {
          upperBound *= 2.0
        }
      }
    }
    
    func univariate(_ x: Double) -> Double {
      return self.cumulativeProbability(x) - p
    }
    
    let x = try UnivariateSolver.solve(lowerBound, x1: upperBound, absoluteAccuracy: self.solverAbsoluteAccuracy, function: univariate)
    
    return x
  }
  
  /// Returns the natural logarithm of the probability density function (PDF) of this distribution evaluated at the specified point x.
  /// In general, the PDF is the derivative of the cumulativeProbability(x: Double) CDF.
  /// If the derivative does not exist at x, then an appropriate replacement should be returned, e.g. Double.infinity, Double.nan, or the limit inferior or limit superior of the difference quotient.
  ///
  /// - Note: That due to the floating point precision and under/overflow issues, this method will for some distributions be more precise and faster than computing the logarithm of density(x: double).
  ///  The default implementation simply computes the logarithm of density(x: double).
  ///
  /// - Parameter x: the point at which the PDF is evaluated
  /// - Returns: the logarithm of the value of the probability density function at point x
  internal func logDensity(_ x: Double) -> Double {
    return log(self.density(x))
  }
}

#endif
