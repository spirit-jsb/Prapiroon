//
//  PrapiroonError.swift
//  Prapiroon
//
//  Created by Max on 2022/11/7.
//

#if canImport(Foundation)

import Foundation

public enum PrapiroonError: Error {
  
  /// Error thrown when a numerical computation can not be performed because the numerical result failed to converge to a finite value.
  ///
  /// - Parameters:
  ///   - format: message format providing the specific context of the error
  ///   - arguments: arguments
  case convergence(format: String, arguments: [CVarArg])
  
  /// Exception to be thrown when some counter maximum value is exceeded.
  ///
  /// - Parameters:
  ///   - format: message format providing the specific context of the error
  ///   - maximum: maximum
  ///   - arguments: arguments
  case maxCountExceeded(format: String, maximum: NSNumber, arguments: [CVarArg])
  
  /// Exception to be thrown when the argument is not greater than 0.
  ///
  /// - Parameters:
  ///   - value: argument
  case notStrictlyPositive(value: NSNumber)
  
  /// Exception to be thrown when a number is too large.
  ///
  /// - Parameters:
  ///   - wrong: value that is larger than the maximum
  ///   - maximum: maximum
  ///   - isBoundAllowed: whether maximum is included in the allowed range
  case numberIsTooLarge(wrong: NSNumber, maximum: NSNumber, isBoundAllowed: Bool)
  
  /// Exception to be thrown when a number is too small.
  ///
  /// - Parameters:
  ///   - wrong: value that is smaller than the minimum
  ///   - minimum: minimum
  ///   - isBoundAllowed: whether minimum is included in the allowed range
  case numberIsTooSmall(wrong: NSNumber, minimum: NSNumber, isBoundAllowed: Bool)
  
  /// Exception to be thrown when some argument is out of range.
  ///
  /// - Parameters:
  ///   - wrong: requested value
  ///   - lowerBound: lower bound
  ///   - higherBound: higher bound
  case outOfRange(wrong: NSNumber, lowerBound: NSNumber, higherBound: NSNumber)
}

extension PrapiroonError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
      case .convergence(format: let format, arguments: let arguments):
        return String(format: format, arguments: arguments)
      case .maxCountExceeded(format: let format, maximum: let maximum, arguments: let arguments):
        return String(format: format, arguments: [maximum] + arguments)
      case .notStrictlyPositive(value: let value):
        return PrapiroonError.numberIsTooSmall(wrong: value, minimum: .init(value: Int.zero), isBoundAllowed: false).errorDescription
      case .numberIsTooLarge(wrong: let wrong, maximum: let maximum, isBoundAllowed: let isBoundAllowed):
        return isBoundAllowed ? "\(wrong) is larger than the maximum (\(maximum))" : "\(wrong) is larger than, or equal to, the maximum (\(maximum))"
      case .numberIsTooSmall(wrong: let wrong, minimum: let minimum, isBoundAllowed: let isBoundAllowed):
        return isBoundAllowed ? "\(wrong) is smaller than the minimum (\(minimum))" : "\(wrong) is smaller than, or equal to, the minimum (\(minimum))"
      case .outOfRange(wrong: let wrong, lowerBound: let lowerBound, higherBound: let higherBound):
        return "\(wrong) out of [\(lowerBound), \(higherBound)] range"
    }
  }
}

#endif
