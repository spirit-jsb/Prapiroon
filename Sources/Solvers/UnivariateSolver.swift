//
//  UnivariateSolver.swift
//  Prapiroon
//
//  Created by Max on 2022/11/8.
//
//  Based on https://commons.apache.org/proper/commons-math/javadocs/api-3.6.1/src-html/org/apache/commons/math3/analysis/solvers/UnivariateSolverUtils.html

#if canImport(Foundation)

import Foundation

internal struct UnivariateSolver {
  
  /// Compute the value of the function.
  ///
  /// - Parameter x: the point at which the function value should be computed.
  /// - Returns: the value of the function.
  internal typealias UnivariateFunction = (_ x: Double) -> Double
  
  /// Convenience method to find a zero of a univariate real function.
  /// A default solver is used.
  ///
  /// - Parameters:
  ///   - x0: lower bound for the interval.
  ///   - x1: upper bound for the interval.
  ///   - absoluteAccuracy: accuracy to be used by the solver.
  ///   - function: function
  ///
  /// - Returns: a value where the function is zero.
  ///
  /// - Throws: Error
  internal static func solve(x0: Double, x1: Double, absoluteAccuracy: Double, function: UnivariateFunction?) throws -> Double {
    fatalError("Not implemented yet.")
  }
}

#endif
