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
/// Default implementations are provided for some of the methods that do not vary from distribution to distribution.
public class AbstractRealDistribution: RealDistribution {
  
  /// Solver absolute accuracy for inverse cumulative computation
  internal private(set) var solverAbsoluteAccuracy: Double = 1e-6
  
  internal private(set) var numericalMean: Double = 0.0
  
  /// Returns the natural logarithm of the probability density function (PDF) of this distribution evaluated at the specified point x.
  /// In general, the PDF is the derivative of the cumulativeProbability(x: Double) CDF.
  /// If the derivative does not exist at x, then an appropriate replacement should be returned, e.g. Double.infinity, Double.nan, or the limit inferior or limit superior of the difference quotient.
  ///
  /// - Note: That due to the floating point precision and under/overflow issues, this method will for some distributions be more precise and faster than computing the logarithm of density(x: double).
  ///  The default implementation simply computes the logarithm of density(x: double).
  ///
  /// - Parameter x: the point at which the PDF is evaluated
  ///
  /// - Returns: the logarithm of the value of the probability density function at point x
  internal func logDensity(x: Double) -> Double {
    return log(self.density(x: x))
  }
}

#endif
