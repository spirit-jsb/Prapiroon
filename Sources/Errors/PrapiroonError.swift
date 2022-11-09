//
//  PrapiroonError.swift
//  Prapiroon
//
//  Created by Max on 2022/11/7.
//

#if canImport(Foundation)

import Foundation

public enum PrapiroonError: Error {
  
  public enum NotStrictlyPositive {
    case standardDeviation(_ sd: Double)
  }
  
  case numberIsTooSmall(_ wrong: Double, minimum: Double, isBoundAllowed: Bool)
  case numberIsTooLarge(_ wrong: Double, maximum: Double, isBoundAllowed: Bool)
  
  case outOfRange(_ wrong: Double, lowerBound: Double, higherBound: Double)
}

extension PrapiroonError.NotStrictlyPositive: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
      case .standardDeviation(let sd):
        return "not strictly positive standard deviation (\(sd))"
    }
  }
}

extension PrapiroonError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
      case .numberIsTooSmall(let wrong, minimum: let minimum, isBoundAllowed: let isBoundAllowed):
        return isBoundAllowed ? "\(wrong) is smaller than the minimum (\(minimum))" : "\(wrong) is smaller than, or equal to, the minimum (\(minimum))"
      case .numberIsTooLarge(let wrong, maximum: let maximum, isBoundAllowed: let isBoundAllowed):
        return isBoundAllowed ? " \(wrong) is larger than the maximum (\(maximum))" : " \(wrong) is larger than, or equal to, the maximum (\(maximum))"
      case .outOfRange(let wrong, lowerBound: let lowerBound, higherBound: let higherBound):
        return "\(wrong) out of [\(lowerBound), \(higherBound)] range"
    }
  }
}

#endif
