//
//  RealDistribution.swift
//  Prapiroon
//
//  Created by Max on 2022/11/7.
//
//  Based on https://commons.apache.org/proper/commons-math/javadocs/api-3.6.1/src-html/org/apache/commons/math3/distribution/RealDistribution.html

#if canImport(Foundation)

import Foundation

internal protocol RealDistribution {
  
  /// Get the numerical value of the mean of this distribution.
  ///
  /// - Returns: the mean or Double.nan if it is not defined
  var numericalMean: Double { get }
  
  /// Get the numerical value of the variance of this distribution.
  ///
  /// - Returns: the variance (possibly Double.infinity) or Double.nan if it is not defined
  var numericalVariance: Double { get }
  
  /// Access the lower bound of the support.
  /// This method must return the same value as inverseCumulativeProbability(p: 0.0).
  /// In other words, this method must return inf{x in R | P(X <= x) > 0}
  ///
  /// - Returns: lower bound of the support (might be -Double.infinity)
  var supportLowerBound: Double { get }
  
  /// Access the upper bound of the support.
  /// This method must return the same value as inverseCumulativeProbability(p: 1.0).
  /// In other words, this method must return inf{x in R | P(X <= x) = 1}
  ///
  /// - Returns: upper bound of the support (might be Double.infinity)
  var supportUpperBound: Double { get }
  
  /// For a random variable X whose values are distributed according to this distribution, this method returns P(X = x).
  /// In other words, this method represents the probability mass function (PMF) for the distribution.
  ///
  /// - Parameter x: the point at which the PMF is evaluated
  ///
  /// - Returns: the value of the probability mass function at point x
  func probability(x: Double) -> Double
  
  /// Returns the probability density function (PDF) of this distribution evaluated at the specified point x.
  /// In general, the PDF is the derivative of the cumulativeProbability(double) CDF.
  /// If the derivative does not exist at x, then an appropriate replacement should be returned, e.g. Double.infinity, Double.nan, or  the limit inferior or limit superior of the difference quotient.
  ///
  /// - Parameter x: the point at which the PDF is evaluated
  ///
  /// - Returns: the value of the probability density function at point x
  func density(x: Double) -> Double
  
  /// For a random variable {@code X} whose values are distributed according to this distribution, this method returns P(X <= x).
  /// In other words, this method represents the cumulative distribution function (CDF) for this distribution.
  ///
  /// - Parameter x: the point at which the CDF is evaluated
  ///
  /// - Returns: the probability that a random variable with this distribution takes a value less than or equal to x
  func cumulativeProbability(x: Double) -> Double
  
  /// Computes the quantile function of this distribution.
  /// For a random variable X distributed according to this distribution, the returned value is
  /// inf{x in R | P(X<=x) >= p} for 0 < p <= 1,
  /// inf{x in R | P(X<=x) > 0} for p = 0.
  ///
  /// - Parameter p: the cumulative probability
  ///
  /// - Returns: the smallest p-quantile of this distribution (largest 0-quantile for p = 0)
  ///
  /// - Throws: PrapiroonError.outOfRange
  func inverseCumulativeProbability(p: Double) throws -> Double
}

extension RealDistribution {
  
  var numericalMean: Double {
    fatalError("Not implemented yet.")
  }
  
  var numericalVariance: Double {
    fatalError("Not implemented yet.")
  }
  
  var supportLowerBound: Double {
    fatalError("Not implemented yet.")
  }
  
  var supportUpperBound: Double {
    fatalError("Not implemented yet.")
  }
  
  func probability(x: Double) -> Double {
    fatalError("Not implemented yet.")
  }
  
  func density(x: Double) -> Double {
    fatalError("Not implemented yet.")
  }
  
  func cumulativeProbability(x: Double) -> Double {
    fatalError("Not implemented yet.")
  }
  
  func inverseCumulativeProbability(p: Double) throws -> Double {
    fatalError("Not implemented yet.")
  }
}

#endif
