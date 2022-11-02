//
//  GradientCircularSlider.swift
//  Clean_Test_App
//
//  Created by Md Murad Hossain on 1/11/22.
//

import Foundation
import UIKit

class GradientCircularSlider: CircularSlider {
  // Array with two colors to create gradation between
    var unfilledGradientColors: [UIColor] = [.green, .lightGray] {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func drawLine(_ ctx: CGContext) {
    if unfilledGradientColors.count == 1 {
      CircularTrig.drawUnfilledGradientArcInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), maximumAngle: maximumAngle , colors: unfilledGradientColors, lineCap: unfilledArcLineCap)
    } else {
      print("The array 'colors' must contain exactly two colors to create a gradient")
    }
  }
}
