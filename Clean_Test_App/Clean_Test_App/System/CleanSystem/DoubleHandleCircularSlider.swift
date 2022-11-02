//
//  DoubleHandleCircularSlider.swift
//  Clean_Test_App
//
//  Created by Md Murad Hossain on 1/11/22.
//

import UIKit
import Foundation

class DoubleHandleCircularSlider: CircularSlider {
  let secondCircularSliderHandle = CircularSliderHandle()
  
  // the minimum distance, in degrees, allowed between handles
  var minimumHandleDistance: CGFloat = 10
  
  // the current value of the upper handle of the slider
  var upperCurrentValue: Float {
    set {
      assert(newValue <= maximumValue && newValue >= minimumValue, "current value \(newValue) must be between minimumValue \(minimumValue) and maximumValue \(maximumValue)")
      // Update the upperAngleFromNorth to match this newly set value
      upperAngleFromNorth = Int((newValue * Float(maximumAngle)) / (maximumValue - minimumValue))
        sendActions(for: UIControl.Event.valueChanged)
    } get {
      return (Float(upperAngleFromNorth) * (maximumValue - minimumValue)) / Float(maximumAngle)
    }
  }
  
  fileprivate var upperAngleFromNorth: Int = 30 {
    didSet {
      assert(upperAngleFromNorth >= 0, "upperAngleFromNorth \(upperAngleFromNorth) must be greater than 0")
    }
  }
  
  // MARK: - Drawing Methods
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let ctx = UIGraphicsGetCurrentContext()
    
    // Draw the second draggable 'handle'
    let handleCenter = super.pointOnCircleAtAngleFromNorth(upperAngleFromNorth)
    secondCircularSliderHandle.frame = super.drawHandle(ctx!, atPoint: handleCenter)
  }
  
  override func drawLine(_ ctx: CGContext) {
    unfilledColor.set()
    // Draw an unfilled circle (this shows what can be filled)
    CircularTrig.drawUnfilledCircleInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), maximumAngle: maximumAngle, lineCap: unfilledArcLineCap)
    
    filledColor.set()
    // Draw an unfilled arc up to the currently filled point
    CircularTrig.drawUnfilledArcInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), fromAngleFromNorth: CGFloat(angleFromNorth), toAngleFromNorth: CGFloat(upperAngleFromNorth), lineCap: filledArcLineCap)
  }
  
  // MARK: - UIControl Functions
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)

    if pointInsideHandle(pointOnCircleAtAngleFromNorth(angleFromNorth), point: location, withEvent: event!) {
      circularSliderHandle.highlighted = true
    } else if pointInsideHandle(pointOnCircleAtAngleFromNorth(upperAngleFromNorth), point: location, withEvent: event!) {
      secondCircularSliderHandle.highlighted = true
    }
    
    return secondCircularSliderHandle.highlighted || circularSliderHandle.highlighted
  }
  
  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    
    let lastPoint = touch.location(in: self)
    let lastAngle = floor(CircularTrig.angleRelativeToNorthFromPoint(centerPoint, toPoint: lastPoint))
    
    if circularSliderHandle.highlighted {
      moveLowerHandle(lastAngle)
    } else if secondCircularSliderHandle.highlighted {
      moveUpperHandle(lastAngle)
    }
    
    sendActions(for: UIControl.Event.valueChanged)
    
    return true
  }
  
  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    circularSliderHandle.highlighted = false
    secondCircularSliderHandle.highlighted = false
  }
  
  fileprivate func moveLowerHandle(_ newAngleFromNorth: CGFloat) {
    let conditionOne = newAngleFromNorth > maximumAngle
    let conditionTwo = newAngleFromNorth > (CGFloat(upperAngleFromNorth) - minimumHandleDistance)
    
    guard !conditionOne && !conditionTwo else {
      // prevent slider from moving past 0
      if conditionOne && conditionTwo && angleFromNorth < Int(maximumAngle / 2) {
        angleFromNorth = 0
      // prevent handles from crossing
      } else if conditionTwo {
        angleFromNorth = Int(upperAngleFromNorth) - Int(minimumHandleDistance)
      }
      
      setNeedsDisplay()
      return
    }
    
    angleFromNorth = Int(newAngleFromNorth)
    setNeedsDisplay()
  }
  
  fileprivate func moveUpperHandle(_ newAngleFromNorth: CGFloat) {
    let conditionOne = newAngleFromNorth > maximumAngle
    let conditionTwo = newAngleFromNorth < CGFloat(angleFromNorth) + minimumHandleDistance
    
    guard !conditionOne && !conditionTwo else {
      // prevent slider from moving past maximumAngle
      if conditionOne && upperAngleFromNorth > Int(maximumAngle / 2) {
        upperAngleFromNorth = Int(maximumAngle)
        // prevent handles from crossing
      } else if conditionTwo {
        upperAngleFromNorth = Int(angleFromNorth) + Int(minimumHandleDistance)
      }
      
      setNeedsDisplay()
      return
    }
    
    upperAngleFromNorth = Int(newAngleFromNorth)
    setNeedsDisplay()
  }
  
  // MARK: - Helper Methods
  
  fileprivate func pointInsideHandle(_ handleCenter: CGPoint, point: CGPoint, withEvent event: UIEvent) -> Bool {
    // Adhere to apple's design guidelines - avoid making touch targets smaller than 44 points
      let handleRadius = max(handleWidth, 44.0) * 0.5
    
    // Treat handle as a box around it's center
    let pointInsideHorzontalHandleBounds = (point.x >= handleCenter.x - handleRadius && point.x <= handleCenter.x + handleRadius)
    let pointInsideVerticalHandleBounds  = (point.y >= handleCenter.y - handleRadius && point.y <= handleCenter.y + handleRadius)
    return pointInsideHorzontalHandleBounds && pointInsideVerticalHandleBounds
  }
}
