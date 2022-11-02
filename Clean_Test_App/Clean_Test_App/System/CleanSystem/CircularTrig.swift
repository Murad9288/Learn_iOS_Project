//
//  CircularTrig.swift
//  Clean_Test_App
//
//  Created by Md Murad Hossain on 1/11/22.
//

import Foundation
import UIKit

open class CircularTrig {
  
  open class func angleRelativeToNorthFromPoint(_ fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
    var v = CGPoint(x: toPoint.x - fromPoint.x, y: toPoint.y - fromPoint.y)
    let vmag = CGFloat(sqrt(square(Double(v.x)) + square(Double(v.y))))
    v.x /= vmag
    v.y /= vmag
    let cartesianRadians = Double(atan2(v.y, v.x))
    // Need to convert from cartesian style radians to compass style
    var compassRadians = cartesianToCompass(cartesianRadians)
    if (compassRadians < 0) {
      compassRadians += (2 * Double.pi)
    }
    assert(compassRadians >= 0 && compassRadians <= 2 * Double.pi, "angleRelativeToNorth should be always positive")
    return CGFloat(toDeg(compassRadians))
  }
  
  open class func pointOnRadius(_ radius: CGFloat, atAngleFromNorth: CGFloat) -> CGPoint {
    //Get the point on the circle for this angle
    var result = CGPoint()
    // Need to adjust from 'compass' style angle to cartesian angle
    let cartesianAngle = CGFloat(compassToCartesian(toRad(Double(atAngleFromNorth))))
    result.y = round(radius * sin(cartesianAngle))
    result.x = round(radius * cos(cartesianAngle))
    
    return result
  }
  
  // MARK: Draw Arcs
  open class func drawFilledCircleInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat) -> CGRect {
    let frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
    ctx.fillEllipse(in: frame)
    return frame
  }
  
  open class func drawUnfilledCircleInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, maximumAngle: CGFloat, lineCap: CGLineCap) {
    // by using maximumAngle an incomplete circle can be drawn
    drawUnfilledArcInContext(ctx, center: center, radius: radius, lineWidth: lineWidth, fromAngleFromNorth: 0, toAngleFromNorth: maximumAngle, lineCap: lineCap)
  }
  
  open class func drawUnfilledArcInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, fromAngleFromNorth: CGFloat, toAngleFromNorth: CGFloat, lineCap: CGLineCap) {
    let cartesianFromAngle = compassToCartesian(toRad(Double(fromAngleFromNorth)))
    let cartesianToAngle = compassToCartesian(toRad(Double(toAngleFromNorth)))

    ctx.addArc(
      center: CGPoint(x: center.x, y: center.y), // arc start point
      radius: radius,     // arc radius from center
      startAngle: CGFloat(cartesianFromAngle),
      endAngle: CGFloat(cartesianToAngle),
      clockwise: false) // iOS flips the y coordinate so anti-clockwise becomes clockwise (desired)!
    
    ctx.setLineWidth(lineWidth)
    ctx.setLineCap(lineCap)
    ctx.drawPath(using: CGPathDrawingMode.stroke)
  }
  
  open class func drawUnfilledGradientArcInContext(_ ctx: CGContext, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, maximumAngle: CGFloat, colors: [UIColor], lineCap: CGLineCap) {
    // ensure two colors exist to create a gradient between
    guard colors.count == 2 else {
      return
    }
    
    let cartesianFromAngle = compassToCartesian(toRad(Double(0)))
    let cartesianToAngle = compassToCartesian(toRad(Double(maximumAngle)))
    
    ctx.saveGState()
    
    let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(cartesianFromAngle), endAngle: CGFloat(cartesianToAngle), clockwise: true)
    let containerPath = CGPath(__byStroking: path.cgPath, transform: nil, lineWidth: CGFloat(lineWidth), lineCap: lineCap, lineJoin: CGLineJoin.round, miterLimit: lineWidth)
    if let containerPath = containerPath {
      ctx.addPath(containerPath)
    }
    ctx.clip()

    let baseSpace = CGColorSpaceCreateDeviceRGB()
    let colors = [colors[1].cgColor, colors[0].cgColor] as CFArray
    let gradient = CGGradient(colorsSpace: baseSpace, colors: colors, locations: nil)
    let startPoint = CGPoint(x: center.x - radius, y: center.y + radius)
    let endPoint = CGPoint(x: center.x + radius, y: center.y - radius)
    if let gradient = gradient {
      ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
    }
    
    ctx.restoreGState()
  }
  
  open class func degreesForArcLength(_ arcLength: CGFloat, onCircleWithRadius radius: CGFloat, withMaximumAngle degrees: CGFloat) -> CGFloat {
    let totalCircumference = CGFloat(2 * Double.pi) * radius
  
    let arcRatioToCircumference = arcLength / totalCircumference
  
    return degrees * arcRatioToCircumference // If arcLength is exactly half circumference, that is exactly half a circle in degrees
  }
  
  // MARK: Calculate radii of arcs with line widths
  /*
  *  For an unfilled arc.
  *
  *  Radius of outer arc (center to outside edge)  |          ---------
  *      = radius + 0.5 * lineWidth                |      +++++++++++++++
  *                                                |    /++/++++ --- ++++\++\
  *  Radius of inner arc (center to inside edge)   |   /++/++/         \++\++\
  *      = radius - (0.5 * lineWidth)              |  |++|++|     .     |++|++|
  *                                         outer edge^  ^-radius-^     ^inner edge
  *
  */
  open class func outerRadiuOfUnfilledArcWithRadius(_ radius: CGFloat, lineWidth: CGFloat) -> CGFloat {
    return radius + 0.5 * lineWidth
  }
  
  open class func innerRadiusOfUnfilledArcWithRadius(_ radius :CGFloat, lineWidth: CGFloat) -> CGFloat {
    return radius - 0.5 * lineWidth
  }
}

// MARK: - Utility Math
extension CircularTrig {
  
  /**
   *  Macro for converting radian degrees from 'compass style' reference (0 radians is along Y axis (ie North on a compass))
   *   to cartesian reference (0 radians is along X axis).
   *
   *  @param rad Radian degrees to convert from 'Compass' reference
   *
   *  @return Radian Degrees in Cartesian reference
   */
  fileprivate class func toRad(_ degrees: Double) -> Double {
    return ((Double.pi * degrees) / 180.0)
  }
  
  fileprivate class func toDeg(_ radians: Double) -> Double {
    return ((180.0 * radians) / Double.pi)
  }
  
  fileprivate class func square(_ value: Double) -> Double {
    return value * value
  }
  
  /**
   *  Macro for converting radian degrees from cartesian reference (0 radians is along X axis)
   *   to 'compass style' reference (0 radians is along Y axis (ie North on a compass)).
   *
   *  @param rad Radian degrees to convert from Cartesian reference
   *
   *  @return Radian Degrees in 'Compass' reference
   */
  fileprivate class func cartesianToCompass(_ radians: Double) -> Double {
    return radians + (Double.pi/2)
  }
  
  fileprivate class func compassToCartesian(_ radians: Double) -> Double {
    return radians - (Double.pi/2)
  }
}
