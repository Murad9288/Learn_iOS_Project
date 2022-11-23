//
//  CropResult.swift
//  Crop_practiice
//
//  Created by Md Murad Hossain on 23/11/22.
//

import Foundation
import UIKit

public struct CropResult {
    public var error: Error?
    public var image: UIImage?
    public var cropFrame: CGRect?
    public var imageSize: CGSize?
    public var realCropFrame: CGRect?

    public init() { }
}
