//
//  Gamma.swift
//  Prapiroon
//
//  Created by Max on 2022/11/8.
//

#if canImport(Foundation)

import Foundation

/// This is a utility class that provides computation methods related to the Gamma family of functions.
///
/// - Note: Implementation of invGamma1pm1(x: Double) and logGamma1p(x: Double) is based on the algorithms described in [Didonato and Morris (1986), Computation of the Incomplete Gamma Function Ratios and their Inverse, TOMS 12(4), 377-393](http://dx.doi.org/10.1145/22721.23109),
/// [Didonato and Morris (1992), Algorithm 708: Significant Digit Computation of the Incomplete Beta Function Ratios, TOMS 18(3), 360-373](http://dx.doi.org/10.1145/131766.131776)
/// and implemented in the [NSWC Library of Mathematical Functions](http://www.dtic.mil/docs/citations/ADA476840), available [here](http://www.ualberta.ca/CNS/RESEARCH/Software/NumericalNSWC/site.html)
///
/// This library is "approved for public release", and the [Copyright guidance](http://www.dtic.mil/dtic/pdf/announcements/CopyrightGuidance.pdf) indicates that unless otherwise stated in the code, all FORTRAN functions in this library are license free.
///
/// Since no such notice appears in the code these functions can safely be ported to Commons-Math.
internal struct Gamma {
  
  /// [Euler-Mascheroni constant](http://en.wikipedia.org/wiki/Euler-Mascheroni_constant)
  internal static let gamma: Double = 0.577215664901532860606512090082
  
  /// The value of the g constant in the Lanczos approximation, see lanczos(x: Double).
  internal static let lanczosG: Double = 607.0 / 128.0
  
  /// Maximum allowed numerical error
  private static let defaultEpsilon: Double = 10e-15
  
  /// Lanczos coefficients
  private static let lanczos: [Double] = [
    0.99999999999999709182,
    57.156235665862923517,
    -59.597960355475491248,
    14.136097974741747174,
    -0.49191381609762019978,
    0.33994649984811888699e-4,
    0.46523628927048575665e-4,
    -0.98374475304879564677e-4,
    0.15808870322491248884e-3,
    -0.21026444172410488319e-3,
    0.21743961811521264320e-3,
    -0.16431810653676389022e-3,
    0.84418223983852743293e-4,
    -0.26190838401581408670e-4,
    0.36899182659531622704e-5,
  ]
  
  /// The constant value of &radic;(2&pi;).
  private static let sqrt2Pi: Double = 2.506628274631000502
  
  // MARK: Limits for switching algorithm in digamma
  
  /// C limit
  private static let cLimit: Double = 49
  /// S limit
  private static let sLimit: Double = 1e-5
  
  // MARK: Constants for the computation of invGamma1pm1(x: Double)
  /// Copied from DGAM1 in the NSWC library.
  
  /// The constant A0 defined in DGAM1
  private static let invGamma1pm1a0: Double = 0.611609510448141581788E-08;
  
  /// The constant A1 defined in DGAM1
  private static let invGamma1pm1a1: Double = 0.624730830116465516210E-08;
  
  /// The constant B1 defined in DGAM1
  private static let invGamma1pm1b1: Double = 0.203610414066806987300E+00;
  
  /// The constant B2 defined in DGAM1
  private static let invGamma1pm1b2: Double = 0.266205348428949217746E-01;
  
  /// The constant B3 defined in DGAM1
  private static let invGamma1pm1b3: Double = 0.493944979382446875238E-03;
  
  /// The constant B4 defined in DGAM1
  private static let invGamma1pm1b4: Double = -0.851419432440314906588E-05;
  
  /// The constant B5 defined in DGAM1
  private static let invGamma1pm1b5: Double = -0.643045481779353022248E-05;
  
  /// The constant B6 defined in DGAM1
  private static let invGamma1pm1b6: Double = 0.992641840672773722196E-06;
  
  /// The constant B7 defined in DGAM1
  private static let invGamma1pm1b7: Double = -0.607761895722825260739E-07;
  
  /// The constant B8 defined in DGAM1
  private static let invGamma1pm1b8: Double = 0.195755836614639731882E-09;
  
  /// The constant C defined in DGAM1
  private static let invGamma1pm1c: Double = -0.422784335098467139393487909917598E+00;
  
  /// The constant C0 defined in DGAM1
  private static let invGamma1pm1c0: Double = 0.577215664901532860606512090082402E+00;
  
  /// The constant C1 defined in DGAM1
  private static let invGamma1pm1c1: Double = -0.655878071520253881077019515145390E+00;
  
  /// The constant C2 defined in DGAM1
  private static let invGamma1pm1c2: Double = -0.420026350340952355290039348754298E-01;
  
  /// The constant C3 defined in DGAM1
  private static let invGamma1pm1c3: Double = 0.166538611382291489501700795102105E+00;
  
  /// The constant C4 defined in DGAM1
  private static let invGamma1pm1c4: Double = -0.421977345555443367482083012891874E-01;
  
  /// The constant C5 defined in DGAM1
  private static let invGamma1pm1c5: Double = -0.962197152787697356211492167234820E-02;
  
  /// The constant C6 defined in DGAM1
  private static let invGamma1pm1c6: Double = 0.721894324666309954239501034044657E-02;
  
  /// The constant C7 defined in DGAM1
  private static let invGamma1pm1c7: Double = -0.116516759185906511211397108401839E-02;
  
  /// The constant C8 defined in DGAM1
  private static let invGamma1pm1c8: Double = -0.215241674114950972815729963053648E-03;
  
  /// The constant C9 defined in DGAM1
  private static let invGamma1pm1c9: Double = 0.128050282388116186153198626328164E-03;
  
  /// The constant C10 defined in DGAM1
  private static let invGamma1pm1c10: Double = -0.201348547807882386556893914210218E-04;
  
  /// The constant C11 defined in DGAM1
  private static let invGamma1pm1c11: Double = -0.125049348214267065734535947383309E-05;
  
  /// The constant C12 defined in DGAM1
  private static let invGamma1pm1c12: Double = 0.113302723198169588237412962033074E-05;
  
  /// The constant C13 defined in DGAM1
  private static let invGamma1pm1c13: Double = -0.205633841697760710345015413002057E-06;
  
  /// The constant P0 defined in DGAM1
  private static let invGamma1pm1p0: Double = 0.6116095104481415817861E-08;
  
  /// The constant P1 defined in DGAM1
  private static let invGamma1pm1p1: Double = 0.6871674113067198736152E-08;
  
  /// The constant P2 defined in DGAM1
  private static let invGamma1pm1p2: Double = 0.6820161668496170657918E-09;
  
  /// The constant P3 defined in DGAM1
  private static let invGamma1pm1p3: Double = 0.4686843322948848031080E-10;
  
  /// The constant P4 defined in DGAM1
  private static let invGamma1pm1p4: Double = 0.1572833027710446286995E-11;
  
  /// The constant P5 defined in DGAM1
  private static let invGamma1pm1p5: Double = -0.1249441572276366213222E-12;
  
  /// The constant P6 defined in DGAM1
  private static let invGamma1pm1p6: Double = 0.4343529937408594255178E-14;
  
  /// The constant Q1 defined in DGAM1
  private static let invGamma1pm1q1: Double = 0.3056961078365221025009E+00;
  
  /// The constant Q2 defined in DGAM1
  private static let invGamma1pm1q2: Double = 0.5464213086042296536016E-01;
  
  /// The constant Q3 defined in DGAM1
  private static let invGamma1pm1q3: Double = 0.4956830093825887312020E-02;
  
  /// The constant Q4 defined in DGAM1
  private static let invGamma1pm1q4: Double = 0.2692369466186361192876E-03;
  
  /// Avoid repeated computation of log of 2 PI in logGamma
  private static let halfLog2Pi: Double = 0.5 * log(2.0 * .pi)
  
  /// Returns the value of log&nbsp;&Gamma;(x) for x > 0.
  ///
  /// - Note: For x &le; 8, the implementation is based on the double precision implementation in the NSWC Library of Mathematics Subroutines, DGAMLN.
  ///
  /// For x &gt; 8, the implementation is based on [Gamma Function](http://mathworld.wolfram.com/GammaFunction.html), equation (28).
  ///
  /// [Lanczos Approximation](http://mathworld.wolfram.com/LanczosApproximation.html), equations (1) through (5).
  ///
  /// [Paul Godfrey, A note on the computation of the convergent Lanczos complex Gamma approximation](http://my.fit.edu/~gabdo/gamma.txt)
  ///
  /// - Parameter x: argument
  ///
  /// - Returns: the value of log(Gamma(x)), Double.NaN if x <= 0.0.
  internal static func logGamma(x: Double) throws -> Double {
    var result: Double
    
    if x <= 0.0 || x.isNaN {
      result = .nan
    }
    else if x < 0.5 {
      return try Gamma.logGamma1p(x: x) - log(x)
    }
    else if x <= 2.5 {
      return try Gamma.logGamma1p(x: (x - 0.5) - 0.5)
    }
    else if x <= 8.0 {
      let n: Int = Int(floor(x - 1.5))
      
      var prod: Double = 1.0
      (1 ... n).forEach { (i) in
        prod *= x - Double(i)
      }
      
      return try Gamma.logGamma1p(x: x - Double(n + 1)) + log(prod)
    }
    else {
      let sum = Gamma.lanczos(x: x)
      let tmp = x + Gamma.lanczosG + 0.5
      
      result = (x + 0.5) * log(tmp) - tmp + Gamma.halfLog2Pi + log(sum / x)
    }
    
    return result
  }
  
  /// Returns the regularized gamma function P(a, x).
  ///
  /// - Parameters:
  ///   - a: parameter
  ///   - x: value
  ///
  /// - Returns: the regularized gamma function P(a, x).
  ///
  /// - Throw: PrapiroonError.maxCountExceeded
  internal static func regularizedGammaP(a: Double, x: Double) throws -> Double {
    return try Gamma.regularizedGammaP(a: a, x: x, epsilon: Gamma.defaultEpsilon, maxIterations: Int.max)
  }
  
  /// Returns the regularized gamma function P(a, x).
  ///
  /// - Note: The implementation of this method is based on:
  ///
  /// [Regularized Gamma Function](http://mathworld.wolfram.com/RegularizedGammaFunction.html), equation (1)
  ///
  /// [Incomplete Gamma Function](http://mathworld.wolfram.com/IncompleteGammaFunction.html), equation (4)
  ///
  /// [Confluent Hypergeometric Function of the First Kind](http://mathworld.wolfram.com/ConfluentHypergeometricFunctionoftheFirstKind.html), equation (1)
  ///
  /// - Parameters:
  ///   - a: parameter
  ///   - x: value
  ///   - epsilon: when the absolute value of the nth item in the series is less than epsilon the approximation ceases to calculate further elements in the series.
  ///   - maxIterations: maximum number of "iterations" to complete
  ///
  /// - Returns: the regularized gamma function P(a, x)
  ///
  /// - Throw: PrapiroonError.maxCountExceeded
  internal static func regularizedGammaP(a: Double, x: Double, epsilon: Double, maxIterations: Int) throws -> Double {
    var result: Double
    
    if a <= 0.0 || a.isNaN || x < 0.0 || x.isNaN {
      result = .nan
    }
    else if x == 0.0 {
      result = 0.0
    }
    else if x >= a + 1.0 {
      // use regularizedGammaP because it should converge faster in this case.
      let regularizedGammaQ = try Gamma.regularizedGammaQ(a: a, x: x, epsilon: epsilon, maxIterations: maxIterations)
      
      result = 1.0 - regularizedGammaQ
    }
    else {
      // calculate series
      var n: Double = 0.0 // current element index
      var an: Double = 1.0 / a // n-th element in the series
      
      var sum: Double = an // partial sum
      
      while abs(an / sum) > epsilon && n < Double(maxIterations) && sum < Double.infinity {
        // compute next element in the series
        n += 1.0
        an *= x / (a + n)
        
        // update partial sum
        sum += an
      }
      
      if n >= Double(maxIterations) {
        throw PrapiroonError.maxCountExceeded(format: "maximal count (%@) exceeded", maximum: NSNumber(value: maxIterations), arguments: [])
      }
      else if sum.isInfinite {
        result = 1.0
      }
      else {
        let logGamma = try Gamma.logGamma(x: a)
        
        result = exp(-x + (a * log(x)) - logGamma) * sum
      }
    }
    
    return result
  }
  
  /// Returns the regularized gamma function Q(a, x) = 1 - P(a, x).
  ///
  /// - Parameters:
  ///   - a: parameter
  ///   - x: value
  ///
  /// - Returns: the regularized gamma function Q(a, x)
  ///
  /// - Throw: PrapiroonError.maxCountExceeded
  internal static func regularizedGammaQ(a: Double, x: Double) throws -> Double {
    return try Gamma.regularizedGammaQ(a: a, x: x, epsilon: Gamma.defaultEpsilon, maxIterations: Int.max)
  }
  
  /// Returns the regularized gamma function Q(a, x) = 1 - P(a, x).
  ///
  /// - Note: The implementation of this method is based on:
  ///
  /// [Regularized Gamma Function](http://mathworld.wolfram.com/RegularizedGammaFunction.html), equation (1)
  ///
  /// [Regularized incomplete gamma function: Continued fraction representations (formula 06.08.10.0003)](http://functions.wolfram.com/GammaBetaErf/GammaRegularized/10/0003/)
  ///
  /// - Parameters:
  ///   - a: parameter
  ///   - x: value
  ///   - epsilon: when the absolute value of the nth item in the series is less than epsilon the approximation ceases to calculate further elements in the series.
  ///   - maxIterations: maximum number of "iterations" to complete
  ///
  /// - Returns: the regularized gamma function Q(a, x)
  ///
  /// - Throw: PrapiroonError.maxCountExceeded
  internal static func regularizedGammaQ(a: Double, x: Double, epsilon: Double, maxIterations: Int) throws -> Double {
    var result: Double
    
    if a <= 0.0 || a.isNaN || x < 0.0 || x.isNaN {
      result = .nan
    }
    else if x == 0.0 {
      result = 1.0
    }
    else if x < a + 1.0 {
      // use regularizedGammaP because it should converge faster in this case.
      let regularizedGammaP = try Gamma.regularizedGammaP(a: a, x: x, epsilon: epsilon, maxIterations: maxIterations)
      
      result = 1.0 - regularizedGammaP
    }
    else {
      // create continued fraction
      func getA(_ n: Int, _ x: Double) -> Double {
        return (2.0 * Double(n) + 1.0) - a + x
      }
      
      func getB(_ n: Int, _ x: Double) -> Double {
        return Double(n) * (a - Double(n))
      }
      
      let continuedFraction = ContinuedFraction(getA: getA, getB: getB)
      
      let evaluate = try continuedFraction.evaluate(x: x, epsilon: epsilon, maxIterations: maxIterations)
      let logGamma = try Gamma.logGamma(x: a)
      
      result = 1.0 / evaluate
      
      result *= exp(-x + (a * log(x)) - logGamma)
    }
    
    return result
  }
  
  /// Computes the digamma function of x.
  ///
  /// - Note: This is an independently written implementation of the algorithm described in Jose Bernardo, Algorithm AS 103: Psi (Digamma) Function, Applied Statistics, 1976.
  ///
  /// Some of the constants have been changed to increase accuracy at the moderate expense of run-time.
  /// The result should be accurate to within 10^-8 absolute tolerance for x >= 10^-5 and within 10^-8 relative tolerance for x > 0.
  ///
  /// Performance for large negative values of x will be quite expensive (proportional to |x|).
  /// Accuracy for negative values of x should be about 10^-8 absolute for results less than 10^5 and 10^-8 relative for results larger than that.
  ///
  /// - Note: [Digamma](http://en.wikipedia.org/wiki/Digamma_function)
  ///
  /// [Bernardo&apos;s original article](http://www.uv.es/~bernardo/1976AppStatist.pdf)
  ///
  /// - Parameter x: argument
  ///
  /// - Returns: digamma(x: x) to within 10-8 relative or absolute error whichever is smaller.
  internal static func digamma(x: Double) -> Double {
    guard !x.isNaN && !x.isInfinite else {
      return x
    }
    
    guard x > Gamma.sLimit || x <= 0.0 else {
      // use method 5 from Bernardo AS103
      // accurate to O(x)
      return -Gamma.gamma - 1.0 / x
    }
    
    guard x < Gamma.cLimit else {
      // use method 4 (accurate to O(1/x^8)
      let inv: Double = 1.0 / (x * x)
      
      //            1       1        1         1
      // log(x) -  --- - ------ + ------- - -------
      //           2 x   12 x^2   120 x^4   252 x^6
      
      return log(x) - 0.5 / x - inv * ((1.0 / 12.0) + inv * (1.0 / 120.0 - inv / 252.0))
    }
    
    return Gamma.digamma(x: x + 1.0) - 1.0 / x
  }
  
  /// Computes the trigamma function of x.
  ///
  /// - Note: This function is derived by taking the derivative of the implementation of digamma.
  ///
  /// [Trigamma](http://en.wikipedia.org/wiki/Trigamma_function)
  ///
  /// - Parameter x: argument
  ///
  /// - Returns: trigamma(x: x) to within 10-8 relative or absolute error whichever is smaller
  internal static func trigamma(x: Double) -> Double {
    guard !x.isNaN && !x.isInfinite else {
      return x
    }
    
    guard x > Gamma.sLimit || x <= 0 else {
      return 1.0 / (x * x)
    }
    
    guard x < Gamma.cLimit else {
      let inv: Double = 1.0 / (x * x)
      
      //  1    1      1       1       1
      //  - + ---- + ---- - ----- + -----
      //  x      2      3       5       7
      //      2 x    6 x    30 x    42 x
      
      return 1.0 / x + inv / 2.0 + inv / x * (1.0 / 6.0 - inv * (1.0 / 30.0 + inv / 42.0))
    }
    
    return Gamma.trigamma(x: x + 1.0) + 1.0 / (x * x)
  }
  
  /// Returns the Lanczos approximation used to compute the gamma function.
  ///
  /// - Note: The Lanczos approximation is related to the Gamma function by the following equation
  ///
  /// gamma(x) = sqrt(2 * pi) / x * (x + g + 0.5) ^ (x + 0.5) * exp(-x - g - 0.5) * lanczos(x) where g is the Lanczos constant.
  ///
  /// [Lanczos Approximation](http://mathworld.wolfram.com/LanczosApproximation.html) equations (1) through (5), and Paul Godfrey's [Note on the computation of the convergent Lanczos complex Gamma approximation](http://my.fit.edu/~gabdo/gamma.txt)
  /// - Parameter x: argument
  ///
  /// - Returns: the Lanczos approximation.
  internal static func lanczos(x: Double) -> Double {
    var sum: Double = 0.0
    
    (1 ..< Gamma.lanczos.count).reversed().forEach { (i) in
      sum += Gamma.lanczos[i] / (x + Double(i))
    }
    
    return sum + Gamma.lanczos[0]
  }
  
  /// Returns the value of 1 / &Gamma;(1 + x) - 1 for -0&#46;5 &le; x &le; 1&#46;5.
  ///
  /// - Note: This implementation is based on the double precision implementation in the NSWC Library of Mathematics Subroutines, DGAM1.
  ///
  /// - Parameter x: argument
  ///
  /// - Returns: the value of 1.0 / Gamma(1.0 + x) - 1.0.
  ///
  /// - Throws: PrapiroonError.numberIsTooSmall if x < -0.5, PrapiroonError.numberIsTooLarge if x > 1.5
  internal static func invGamma1pm1(x: Double) throws -> Double {
    guard x >= -0.5 else {
      throw PrapiroonError.numberIsTooSmall(wrong: NSNumber(value: x), minimum: NSNumber(value: -0.5), isBoundAllowed: true)
    }
    
    guard x <= 1.5 else {
      throw PrapiroonError.numberIsTooLarge(wrong: NSNumber(value: x), maximum: NSNumber(value: 1.5), isBoundAllowed: true)
    }
    
    var result: Double
    
    let t: Double = x <= 0.5 ? x : (x - 0.5) - 0.5
    if t < 0.0 {
      let a: Double = Gamma.invGamma1pm1a0 + t * Gamma.invGamma1pm1a1
      
      var b: Double = Gamma.invGamma1pm1b8
      b = Gamma.invGamma1pm1b7 + t * b
      b = Gamma.invGamma1pm1b6 + t * b
      b = Gamma.invGamma1pm1b5 + t * b
      b = Gamma.invGamma1pm1b4 + t * b
      b = Gamma.invGamma1pm1b3 + t * b
      b = Gamma.invGamma1pm1b2 + t * b
      b = Gamma.invGamma1pm1b1 + t * b
      b = 1.0 + t * b
      
      var c: Double = Gamma.invGamma1pm1c13 + t * (a / b)
      c = Gamma.invGamma1pm1c12 + t * c
      c = Gamma.invGamma1pm1c11 + t * c
      c = Gamma.invGamma1pm1c10 + t * c
      c = Gamma.invGamma1pm1c9 + t * c
      c = Gamma.invGamma1pm1c8 + t * c
      c = Gamma.invGamma1pm1c7 + t * c
      c = Gamma.invGamma1pm1c6 + t * c
      c = Gamma.invGamma1pm1c5 + t * c
      c = Gamma.invGamma1pm1c4 + t * c
      c = Gamma.invGamma1pm1c3 + t * c
      c = Gamma.invGamma1pm1c2 + t * c
      c = Gamma.invGamma1pm1c1 + t * c
      c = Gamma.invGamma1pm1c + t * c
      
      if x > 0.5 {
        result = t * c / x
      }
      else {
        result = x * ((c + 0.5) + 0.5)
      }
    }
    else {
      var p: Double = Gamma.invGamma1pm1p6
      p = Gamma.invGamma1pm1p5 + t * p
      p = Gamma.invGamma1pm1p4 + t * p
      p = Gamma.invGamma1pm1p3 + t * p
      p = Gamma.invGamma1pm1p2 + t * p
      p = Gamma.invGamma1pm1p1 + t * p
      p = Gamma.invGamma1pm1p0 + t * p
      
      var q: Double = Gamma.invGamma1pm1q4
      q = Gamma.invGamma1pm1q3 + t * q
      q = Gamma.invGamma1pm1q2 + t * q
      q = Gamma.invGamma1pm1q1 + t * q
      q = 1.0 + t * q
      
      var c: Double = Gamma.invGamma1pm1c13 + (p / q) * t
      c = Gamma.invGamma1pm1c12 + t * c
      c = Gamma.invGamma1pm1c11 + t * c
      c = Gamma.invGamma1pm1c10 + t * c
      c = Gamma.invGamma1pm1c9 + t * c
      c = Gamma.invGamma1pm1c8 + t * c
      c = Gamma.invGamma1pm1c7 + t * c
      c = Gamma.invGamma1pm1c6 + t * c
      c = Gamma.invGamma1pm1c5 + t * c
      c = Gamma.invGamma1pm1c4 + t * c
      c = Gamma.invGamma1pm1c3 + t * c
      c = Gamma.invGamma1pm1c2 + t * c
      c = Gamma.invGamma1pm1c1 + t * c
      c = Gamma.invGamma1pm1c0 + t * c
      
      if (x > 0.5) {
        result = (t / x) * ((c - 0.5) - 0.5)
      }
      else {
        result = x * c
      }
    }
    
    return result
  }
  
  /// Returns the value of log &Gamma;(1 + x) for -0&#46;5 &le; x &le; 1&#46;5.
  ///
  /// - Note: This implementation is based on the double precision implementation in the NSWC Library of Mathematics Subroutines, DGMLN1.
  ///
  /// - Parameter x: argument
  ///
  /// - Returns: the value of log(Gamma(1 + x)).
  ///
  /// - Throws: PrapiroonError.numberIsTooSmall if x < -0.5, PrapiroonError.numberIsTooLarge if x > 1.5
  internal static func logGamma1p(x: Double) throws -> Double {
    guard x >= -0.5 else {
      throw PrapiroonError.numberIsTooSmall(wrong: NSNumber(value: x), minimum: NSNumber(value: -0.5), isBoundAllowed: true)
    }
    
    guard x <= 1.5 else {
      throw PrapiroonError.numberIsTooLarge(wrong: NSNumber(value: x), maximum: NSNumber(value: 1.5), isBoundAllowed: true)
    }
    
    return -log1p(try Gamma.invGamma1pm1(x: x))
  }
  
  /// Returns the value of &Gamma;(x)
  ///
  /// - Note: Based on the NSWC Library of Mathematics Subroutines double precision implementation, DGAMMA.
  ///
  /// - Parameter x: argument
  ///
  /// - Returns: the value of Gamma(x).
  internal static func gamma(x: Double) throws -> Double {
    guard x != rint(x) || x > 0.0 else {
      return Double.nan
    }
    
    var result: Double
    
    let absX = abs(x)
    if absX <= 20.0 {
      if x >= 1.0 {
        /*
         * From the recurrence relation
         * Gamma(x) = (x - 1) * ... * (x - n) * Gamma(x - n),
         * then
         * Gamma(t) = 1 / [1 + invGamma1pm1(t - 1)],
         * where t = x - n. This means that t must satisfy
         * -0.5 <= t - 1 <= 1.5.
         */
        var prod: Double = 1.0
        var t = x
        while t > 2.5 {
          t -= 1.0
          prod *= t
        }
        
        let invGamma1pm1 = try Gamma.invGamma1pm1(x: t - 1.0)
        
        result = prod / (1.0 + invGamma1pm1)
      }
      else {
        /*
         * From the recurrence relation
         * Gamma(x) = Gamma(x + n + 1) / [x * (x + 1) * ... * (x + n)]
         * then
         * Gamma(x + n + 1) = 1 / [1 + invGamma1pm1(x + n)],
         * which requires -0.5 <= x + n <= 1.5.
         */
        var prod = x
        var t = x
        while t < -0.5 {
          t += 1.0
          prod *= t
        }
        
        let invGamma1pm1 = try Gamma.invGamma1pm1(x: t)
        
        result = 1.0 / (prod * (1.0 + invGamma1pm1))
      }
    }
    else {
      let y: Double = absX + Gamma.lanczosG + 0.5
      let gammaAbs = Gamma.sqrt2Pi / absX * pow(y, absX + 0.5) * exp(-y) * Gamma.lanczos(x: absX)
      
      if x > 0.0 {
        result = gammaAbs
      }
      else {
        /*
         * From the reflection formula
         * Gamma(x) * Gamma(1 - x) * sin(pi * x) = pi,
         * and the recurrence relation
         * Gamma(1 - x) = -x * Gamma(-x),
         * it is found
         * Gamma(x) = -pi / [x * sin(pi * x) * Gamma(-x)].
         */
        result = -(Double.pi) / (x * sin(.pi * x) * gammaAbs)
      }
    }
    
    return result
  }
}

#endif
