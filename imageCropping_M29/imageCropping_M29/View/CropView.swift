//
//  cropView.swift
//  imageCropping_M29
//
//  Created by Md Murad Hossain on 19/11/22.
//

import Foundation
import UIKit

class CropView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func point(inside point: CGPoint, with event:   UIEvent?) -> Bool {
        return false
    }
}
