//
//  ContinuedFractionTests.swift
//  PrapiroonTests
//
//  Created by Max on 2022/12/2.
//

import XCTest
@testable import Prapiroon

final class ContinuedFractionTests: XCTestCase {
  
  func test_goldenRatio() {
    
    func getA(_ n: Int, _ x: Double) -> Double {
      return 1.0
    }
    
    func getB(_ n: Int, _ x: Double) -> Double {
      return 1.0
    }
    
    let continuedFraction = ContinuedFraction(getA: getA, getB: getB)
    
    let goldenRatio = try! continuedFraction.evaluate(x: 0.0, epsilon: 10e-9)
    
    XCTAssertEqual(1.61803399, goldenRatio, accuracy: 10e-9)
  }
}
