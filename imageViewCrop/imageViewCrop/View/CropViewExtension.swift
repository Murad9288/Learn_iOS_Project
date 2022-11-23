//
//  CropViewExtension.swift
//  imageViewCrop
//
//  Created by Md Murad Hossain on 19/11/22.
//

import UIKit

//MARK: Extending View to get constraint Value

extension UIView {
    var imageWithView: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        if let cgContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: cgContext)
        }
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func edgesConstraint(subView: UIView, constant: CGFloat = 0) {
        self.leadingConstraint(subView: subView, constant: constant)
        self.trailingConstraint(subView: subView, constant: constant)
        self.topConstraint(subView: subView, constant: constant)
        self.bottomConstraint(subView: subView, constant: constant)
    }
    
    func sizeConstraint(subView: UIView, constant: CGFloat = 0) {
        self.widthConstraint(subView: subView, constant: constant)
        self.heightConstraint(subView: subView, constant: constant)
    }
    
    func sizeConstraint(constant: CGFloat = 0) {
        self.widthConstraint(constant: constant)
        self.heightConstraint(constant: constant)
    }
    
    @discardableResult
    func leadingConstraint(subView: UIView,
                           constant: CGFloat = 0,
                           multiplier: CGFloat = 1,
                           relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .leading,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func trailingConstraint(subView: UIView,
                            constant: CGFloat = 0,
                            multiplier: CGFloat = 1,
                            relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .trailing,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func topConstraint(subView: UIView,
                       constant: CGFloat = 0,
                       multiplier: CGFloat = 1,
                       relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .top,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func bottomConstraint(subView: UIView,
                          constant: CGFloat = 0,
                          multiplier: CGFloat = 1,
                          relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .bottom,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerXConstraint(subView: UIView,
                           constant: CGFloat = 0,
                           multiplier: CGFloat = 1,
                           relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .centerX,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .centerX,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerYConstraint(subView: UIView,
                           constant: CGFloat = 0,
                           multiplier: CGFloat = 1,
                           relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .centerY,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .centerY,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func leadingConstraint(item: UIView,
                           subView: UIView,
                           constant: CGFloat = 0,
                           multiplier: CGFloat = 1,
                           relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .leading,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .leading,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func trailingConstraint(item: UIView,
                            subView: UIView,
                            constant: CGFloat = 0,
                            multiplier: CGFloat = 1,
                            relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .trailing,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .trailing,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func topConstraint(item: UIView,
                       subView: UIView,
                       constant: CGFloat = 0,
                       multiplier: CGFloat = 1,
                       relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .top,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .top,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func bottomConstraint(item: UIView,
                          subView: UIView,
                          constant: CGFloat = 0,
                          multiplier: CGFloat = 1,
                          relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .bottom,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .bottom,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerXConstraint(item: UIView,
                           subView: UIView,
                           constant: CGFloat = 0,
                           multiplier: CGFloat = 1,
                           relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .centerX,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .centerX,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func centerYConstraint(item: UIView,
                           subView: UIView,
                           constant: CGFloat = 0,
                           multiplier: CGFloat = 1,
                           relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .centerY,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .centerY,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func widthConstraint(item: UIView,
                         subView: UIView,
                         constant: CGFloat = 0,
                         multiplier: CGFloat = 1,
                         relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .width,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func heightConstraint(item: UIView,
                          subView: UIView,
                          constant: CGFloat = 0,
                          multiplier: CGFloat = 1,
                          relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: .height,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .height,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func widthConstraint(subView: UIView,
                         constant: CGFloat = 0,
                         multiplier: CGFloat = 1,
                         relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func heightConstraint(subView: UIView,
                          constant: CGFloat = 0,
                          multiplier: CGFloat = 1,
                          relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: relatedBy,
                                            toItem: subView,
                                            attribute: .height,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func widthConstraint(constant: CGFloat = 0,
                         multiplier: CGFloat = 1,
                         relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: relatedBy,
                                            toItem: nil,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func heightConstraint(constant: CGFloat = 0,
                          multiplier: CGFloat = 1,
                          relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: relatedBy,
                                            toItem: nil,
                                            attribute: .height,
                                            multiplier: multiplier,
                                            constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
}
extension NSLayoutConstraint {
    func priority(_ value: CGFloat) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(Float(value))
        return self
    }
}
extension UIBezierPath {
    @discardableResult
    func move(_ x: CGFloat, _ y: CGFloat) -> UIBezierPath{
        self.move(to: CGPoint(x: x, y: y))
        return self
    }
    
    @discardableResult
    func line(_ x: CGFloat, _ y: CGFloat) -> UIBezierPath {
        self.addLine(to: CGPoint(x: x, y: y))
        return self
    }
    
    @discardableResult
    func closed() -> UIBezierPath {
        self.close()
        return self
    }
    
    @discardableResult
    func strokeFill(_ color: UIColor, lineWidth: CGFloat = 1) -> UIBezierPath {
        color.set()
        self.lineWidth = lineWidth
        self.stroke()
        self.fill()
        return self
    }
    
    @discardableResult
    func stroke(_ color: UIColor, lineWidth: CGFloat = 1) -> UIBezierPath {
        color.set()
        self.lineWidth = lineWidth
        self.stroke()
        return self
    }
}

//MARK: Extending FrameworkClasses
//MARK:UIIMageView Extension to get Frame

extension UIImageView {
    var frameForImageInImageViewAspectFit: CGRect {
        if  let img = self.image {
            let imageRatio = img.size.width / img.size.height
            let viewRatio = self.frame.size.width / self.frame.size.height
            if(imageRatio < viewRatio) {
                let scale = self.frame.size.height / img.size.height
                let width = scale * img.size.width
                let topLeftX = (self.frame.size.width - width) * 0.5
                return CGRect(x: topLeftX, y: 0, width: width, height: self.frame.size.height)
            } else {
                let scale = self.frame.size.width / img.size.width
                let height = scale * img.size.height
                let topLeftY = (self.frame.size.height - height) * 0.5
                return CGRect(x: 0, y: topLeftY, width: self.frame.size.width, height: height)
            }
        }
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    var imageFrame: CGRect {
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else { return CGRect.zero }
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        } else {
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}

// MARK: UIImage configuration

extension UIImage {
    var fixOrientation: UIImage? {
        
        if imageOrientation == .up { return self }
        var transform = CGAffineTransform.identity

        if imageOrientation == .down || imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }

        if imageOrientation == .left || imageOrientation == .leftMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }

        if imageOrientation == .right || imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0))
        }

        if imageOrientation == .upMirrored || imageOrientation == .downMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if imageOrientation == .leftMirrored || imageOrientation == .rightMirrored {
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        guard let cgImage = cgImage,
            let colorSpace = cgImage.colorSpace else { return nil }

        guard let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                  bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }

        ctx.concatenate(transform)

        if imageOrientation == .left ||
            imageOrientation == .leftMirrored ||
            imageOrientation == .right ||
            imageOrientation == .rightMirrored {
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        } else {
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        guard let makeImage = ctx.makeImage() else { return nil }
        return UIImage(cgImage: makeImage)
    }
}
