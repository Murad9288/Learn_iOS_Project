//
//  uiviewExtension.swift
//  Image_Crop
//
//  Created by Md Murad Hossain on 15/11/22.
//
// MARK: Eamil -> muradhossainm01@gmail.com


import Foundation
import UIKit

extension UIView {

    private class CustomShapeLayer: CAShapeLayer {}
    
    private func removeOldCustomLayers(){
        self.layer.sublayers?.forEach {
            ($0 as? CustomShapeLayer)?.removeFromSuperlayer()
        }
    }
    
    private func addSolidBorder(color: UIColor){
        
        let dashedBorderLayer = CustomShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        dashedBorderLayer.bounds = shapeRect
        dashedBorderLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        dashedBorderLayer.fillColor = UIColor.clear.cgColor
        dashedBorderLayer.strokeColor = color.cgColor
        dashedBorderLayer.lineWidth = 2
        dashedBorderLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath

        self.layer.addSublayer(dashedBorderLayer)
    }
    
    private func addDashedBorder(color: UIColor){
        
        let dashedBorderLayer = CustomShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        dashedBorderLayer.bounds = shapeRect
        dashedBorderLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        dashedBorderLayer.fillColor = UIColor.clear.cgColor
        dashedBorderLayer.strokeColor = color.cgColor
        dashedBorderLayer.lineWidth = 2
        dashedBorderLayer.lineJoin = CAShapeLayerLineJoin.round
        dashedBorderLayer.lineDashPattern = [8,8]
        dashedBorderLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath

        self.layer.addSublayer(dashedBorderLayer)
    }
    
    func addCustomShapeBorderLayers() {
        removeOldCustomLayers()
        addSolidBorder(color: .white)
        addDashedBorder(color: .black)
    }
}
