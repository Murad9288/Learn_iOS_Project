//
//  ImageCropView.swift
//  imageViewCrop
//
//  Created by Md Murad Hossain on 19/11/22.
//

import UIKit

// CropPickerView Delegate
protocol CropPickerViewDelegate: AnyObject {
    // Called when the image or error.
    //func cropPickerView(_ cropPickerView: ImageCropView, result: CropResult)
    func cropPickerView(_ cropPickerView: ImageCropView, didChange frame: CGRect)
}

extension CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: ImageCropView, didChange frame: CGRect) {

    }
}


@IBDesignable
public class ImageCropView: UIView {
  var delegate: CropPickerViewDelegate?
    
    // MARK: Public Property
    
    public var cropMinSize: CGFloat = 20

    // Set Image
    @IBInspectable
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue?.fixOrientation
            scrollView.setZoomScale(1, animated: false)
            initVars()
            cropLineHidden(image)
            scrollView.layoutIfNeeded()
            dimLayerMask(animated: false)
            DispatchQueue.main.async {
                self.imageMinAdjustment(animated: false)
            }
        }
    }
    
    // Set Image
    @IBInspectable
    public var changeImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue?.fixOrientation
        }
    }
    
    // Line color of crop view
    @IBInspectable
    public var cropLineColor: UIColor? {
        get {
            return cropView.lineColor
        }
        set {
            cropView.lineColor = newValue
            leftTopButton.edgeLine(newValue)
            leftBottomButton.edgeLine(newValue)
            rightTopButton.edgeLine(newValue)
            rightBottomButton.edgeLine(newValue)
            topButton.edgeLine(newValue)
            leftButton.edgeLine(newValue)
            rightButton.edgeLine(newValue)
            bottomButton.edgeLine(newValue)
        }
    }
    
    // Background color of scroll
    @IBInspectable
    public var scrollBackgroundColor: UIColor? {
        get {
            return scrollView.backgroundColor
        }
        set {
            scrollView.backgroundColor = newValue
        }
    }
    
    // Background color of image
    @IBInspectable
    public var imageBackgroundColor: UIColor? {
        get {
            return imageView.backgroundColor
        }
        set {
            imageView.backgroundColor = newValue
        }
    }
    
    // Color of dim view not in the crop area
    @IBInspectable
    public var dimBackgroundColor: UIColor? {
        get {
            return dimView.backgroundColor
        }
        set {
            dimView.backgroundColor = newValue
        }
    }
    
    // Minimum zoom for scrolling
    @IBInspectable
    public var scrollMinimumZoomScale: CGFloat {
        get {
            return scrollView.minimumZoomScale
        }
        set {
            scrollView.minimumZoomScale = newValue
        }
    }
    
    // Maximum zoom for scrolling
    @IBInspectable
    public var scrollMaximumZoomScale: CGFloat {
        get {
            return scrollView.maximumZoomScale
        }
        set {
            scrollView.maximumZoomScale = newValue
        }
    }

    // crop radius
    @IBInspectable
    public var radius: CGFloat = 0 {
        didSet {
            dimLayerMask(animated: false)
        }
    }

    // If false, the cropview and dimview will disappear and only the view will be zoomed in or out.
    public var isCrop = true {
        willSet {
            topButton.isHidden = !newValue
            bottomButton.isHidden = !newValue
            leftButton.isHidden = !newValue
            rightButton.isHidden = !newValue
            leftTopButton.isHidden = !newValue
            leftBottomButton.isHidden = !newValue
            rightTopButton.isHidden = !newValue
            rightBottomButton.isHidden = !newValue
            centerButton.isHidden = !newValue
            dimView.isHidden = !newValue
            cropView.isHidden = !newValue
        }
    }

    public var aspectRatio: CGFloat = 0 {
        didSet {
            if isRate {
                var leading: CGFloat = 0
                var trailing: CGFloat = 0
                var top: CGFloat = 0
                var bottom: CGFloat = 0
                let width = bounds.width + leading - trailing
                let height = bounds.height + top - bottom
                let widthRate = width / bounds.width
                let heightRate = height / bounds.height
                if widthRate > heightRate {
                    let margin = (bounds.width - (height * aspectRatio)) / 2
                    if margin > 0 {
                        leading = -margin
                        trailing = margin
                    } else {
                        let margin = (bounds.height - (width / aspectRatio)) / 2
                        top = -margin
                        bottom = margin
                    }
                } else {
                    let margin = (bounds.height - (width / aspectRatio)) / 2
                    if margin > 0 {
                        top = -margin
                        bottom = margin
                    } else {
                        let margin = (bounds.width - (height * aspectRatio)) / 2
                        leading = -margin
                        trailing = margin
                    }
                }
                cropLeadingConstraint?.constant = leading
                cropTrailingConstraint?.constant = trailing
                cropTopConstraint?.constant = top
                cropBottomConstraint?.constant = bottom
                dimLayerMask(0, animated: false)
                
                topButton.isHidden = true
                leftButton.isHidden = true
                bottomButton.isHidden = true
                rightButton.isHidden = true
            } else {
                topButton.isHidden = false
                leftButton.isHidden = false
                bottomButton.isHidden = false
                rightButton.isHidden = false
            }
        }
    }
    
    // MARK: Private Property
    
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alpha = 1
        return scrollView
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal let dimView: CropDimView = {
        let view = CropDimView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 1
        return view
    }()
    
    public let cropView: CropView = {
        let cropView = CropView()
        cropView.translatesAutoresizingMaskIntoConstraints = false
        return cropView
    }()
    
    // Side button and corner button of crop
    
    public let leftTopButton: LineButton = {
        let button = LineButton(.leftTop)
        return button
    }()
    
    public let leftBottomButton: LineButton = {
        let button = LineButton(.leftBottom)
        return button
    }()
    
    public let rightTopButton: LineButton = {
        let button = LineButton(.rightTop)
        return button
    }()
    
    public let rightBottomButton: LineButton = {
        let button = LineButton(.rightBottom)
        return button
    }()
    
    public let topButton: LineButton = {
        let button = LineButton(.top)
        return button
    }()
    
    public let leftButton: LineButton = {
        let button = LineButton(.left)
        return button
    }()
    
    public let rightButton: LineButton = {
        let button = LineButton(.right)
        return button
    }()
    
    public let bottomButton: LineButton = {
        let button = LineButton(.bottom)
        return button
    }()
    
    public let centerButton: LineButton = {
        let button = LineButton(.center)
        return button
    }()
    
    private var cropLeadingConstraint: NSLayoutConstraint?
    
    private var cropTrailingConstraint: NSLayoutConstraint?
    
    private var cropTopConstraint: NSLayoutConstraint?
    
    private var cropBottomConstraint: NSLayoutConstraint?
    
    private var lineButtonTouchPoint: CGPoint?
    
    private var isInit = false
    
    private var isRate: Bool {
        return aspectRatio != 0
    }
    
    // MARK: Init
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
    }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        initVars()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Max Image
    func imageMaxAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        imageAdjustment(.zero,
                        duration: duration,
                        animated: animated)
    }
    
    // Min Image
    public func imageMinAdjustment(_ duration: TimeInterval = 0.4, animated: Bool) {
        
        var point: CGPoint
        let imageSize = imageView.frameForImageInImageViewAspectFit
        if isImageRateHeightGreaterThan(imageSize) {
            point = CGPoint(x: 0, y: imageSize.origin.y)
            
        } else {
            point = CGPoint(x: imageSize.origin.x, y: 0)
        }
        imageAdjustment(point,
                        duration: duration,
                        animated: animated)
    }
    
    public func imageAdjustment(_ point: CGPoint,
                                duration: TimeInterval = 0.4,
                                animated: Bool) {
        var leading = -point.x
        var trailing = point.x
        var top = -point.y
        var bottom = point.y
        
        if isRate {
            let width = bounds.width + leading - trailing
            let height = bounds.height + top - bottom
            let widthRate = width / bounds.width
            let heightRate = height / bounds.height
            if widthRate > heightRate {
                let margin = (bounds.width - (height * aspectRatio)) / 2
                if margin > 0 {
                    leading = -margin
                    trailing = margin
                } else {
                    let margin = (bounds.height - (width / aspectRatio)) / 2
                    top = -margin
                    bottom = margin
                }
            } else {
                let margin = (bounds.height - (width / aspectRatio)) / 2
                if margin > 0 {
                    top = -margin
                    bottom = margin
                } else {
                    let margin = (bounds.width - (height * aspectRatio)) / 2
                    leading = -margin
                    trailing = margin
                }
            }
        }
        
        cropLeadingConstraint?.constant = leading
        cropTrailingConstraint?.constant = trailing
        cropTopConstraint?.constant = top
        cropBottomConstraint?.constant = bottom
        
        if animated {
            dimLayerMask(duration, animated: animated)
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            dimLayerMask(duration, animated: animated)
        }
    }

    /****
     image: UIImage
     isMin: Bool set image after min or max image
     crop: set image after crop size
     isRealCropRect: image real crop or image frame crop
    ****/
    
    public func image(_ image: UIImage?,
                      isMin: Bool = true,
                      crop: CGRect? = nil,
                      isRealCropRect: Bool = false) {
        
        imageView.image = image?.fixOrientation
        if isMin {
            scrollView.setZoomScale(1, animated: false)
        } else {
            imageRealSize(false)
        }
        initVars()
        cropLineHidden(image)
        scrollView.layoutIfNeeded()
        dimLayerMask(animated: false)
        
        DispatchQueue.main.async {
            var point: CGPoint = .zero
            
            if isMin {
                let imageSize = self.imageView.frameForImageInImageViewAspectFit
                if self.isImageRateHeightGreaterThan(imageSize) {
                    point = CGPoint(x: 0, y: imageSize.origin.y)
                } else {
                    point = CGPoint(x: imageSize.origin.x, y: 0)
                }
            }
            
            if isRealCropRect {
                point = .zero
            }
            
            var leading = -point.x
            var trailing = point.x
            var top = -point.y
            var bottom = point.y
            if let crop = crop {
                leading = -point.x - crop.origin.x
                trailing = (self.bounds.width - (point.x + crop.origin.x + crop.size.width))
                top = -point.y - crop.origin.y
                bottom = (self.bounds.height - (point.y + crop.origin.y + crop.size.height))
            }
            
            if self.isRate {
                
                let width = self.bounds.width + leading - trailing
                let height = self.bounds.height + top - bottom
                let widthRate = width / self.bounds.width
                let heightRate = height / self.bounds.height
                if widthRate == heightRate {
                    let margin = (self.bounds.width - height) / 2
                    if margin > 0 {
                        leading = -margin
                        trailing = margin
                    } else {
                        let margin = (self.bounds.height - width) / 2
                        top = -margin
                        bottom = margin
                    }
                    
                } else if widthRate > heightRate {
                    
                    let margin = (self.bounds.width - (height * self.aspectRatio)) / 2
                    if margin > 0 {
                        leading = -margin
                        trailing = margin
                    } else {
                        let margin = (self.bounds.height - (width / self.aspectRatio)) / 2
                        top = -margin
                        bottom = margin
                    }
                    
                } else {
                    
                    let margin = (self.bounds.height - (width / self.aspectRatio)) / 2
                    if margin > 0 {
                        top = -margin
                        bottom = margin
                    } else {
                        let margin = (self.bounds.width - (height * self.aspectRatio)) / 2
                        leading = -margin
                        trailing = margin
                    }
                }
            }
            
            self.cropLeadingConstraint?.constant = leading
            self.cropTrailingConstraint?.constant = trailing
            self.cropTopConstraint?.constant = top
            self.cropBottomConstraint?.constant = bottom
            self.dimLayerMask(0.0, animated: false)
        }
    }

    
    // MARK: Public Method
    /**
     crop method.
     If there is no image to crop, Error 404 is displayed.
     If there is no image in the crop area, Error 503 is displayed.
     If the image is successfully cropped, the success delegate or callback function is called.
     **/
    
    public func crop(_ handler: ((Error?, UIImage?) -> Void)? = nil) {
        guard let image = self.imageView.image else {
            let error = NSError(domain: "Image is empty.", code: 404, userInfo: nil)
            handler?(error, nil)
            return
        }
        
        DispatchQueue.main.async {
            let imageSize = self.imageView.frameForImageInImageViewAspectFit
            let widthRate =  self.bounds.width / imageSize.width
            let heightRate = self.bounds.height / imageSize.height
            var factor: CGFloat
            if widthRate < heightRate {
                factor = image.size.width / self.scrollView.frame.width
            } else {
                factor = image.size.height / self.scrollView.frame.height
            }
            let scale = 1 / self.scrollView.zoomScale
            let imageFrame = self.imageView.imageFrame
            let x = (self.scrollView.contentOffset.x + self.cropView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (self.scrollView.contentOffset.y + self.cropView.frame.origin.y - imageFrame.origin.y) * scale * factor
            let width = self.cropView.frame.size.width * scale * factor
            let height = self.cropView.frame.size.height * scale * factor
            let cropArea = CGRect(x: x, y: y, width: width, height: height)
            
            guard let cropCGImage = image.cgImage?.cropping(to: cropArea) else {
                let error = NSError(domain: "There is no image in the Crop area.", code: 533, userInfo: nil)
                handler?(error, nil)
                return
            }
            let cropImage = UIImage(cgImage: cropCGImage)
            handler?(nil, cropImage)
        }
    }
    
}

// MARK: Private Method Image
extension ImageCropView {
    // Modify the contentOffset of the scrollView so that the scroll view fills the image.
    private func imageRealSize(_ animated: Bool = false) {
        if imageView.image == nil { return }
        scrollView.setZoomScale(1, animated: false)
        
        let imageSize = imageView.frameForImageInImageViewAspectFit
        let widthRate =  bounds.width / imageSize.width
        let heightRate = bounds.height / imageSize.height
        if widthRate < heightRate {
            scrollView.setZoomScale(heightRate, animated: animated)
        } else {
            scrollView.setZoomScale(widthRate, animated: animated)
        }
        let x = scrollView.contentSize.width/2 - scrollView.bounds.size.width/2
        let y = scrollView.contentSize.height/2 - scrollView.bounds.size.height/2
        scrollView.contentOffset = CGPoint(x: x, y: y)
    }
}

// MARK: Private Method Init
extension ImageCropView {
    // Side button and corner button group of crops
    private var lineButtonGroup: [LineButton] {
        return [leftTopButton,
                leftBottomButton,
                rightTopButton,
                rightBottomButton,
                topButton,
                leftButton,
                bottomButton,
                rightButton,
                centerButton]
    }
    
    // Init
    private func initVars() {
        if isInit { return }
        isInit = true
        addSubview(scrollView)
        addSubview(cropView)
        addSubview(dimView)
        addSubview(leftTopButton)
        addSubview(leftBottomButton)
        addSubview(rightTopButton)
        addSubview(rightBottomButton)
        addSubview(topButton)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(bottomButton)
        addSubview(centerButton)
        
        scrollView.addSubview(imageView)
        edgesConstraint(subView: scrollView)
        
        scrollView.edgesConstraint(subView: imageView)
        scrollView.sizeConstraint(subView: imageView)
        edgesConstraint(subView: dimView)
        
        cropLeadingConstraint = leadingConstraint(subView: cropView, constant: 0).priority(945)
        cropTrailingConstraint = trailingConstraint(subView: cropView, constant: 0).priority(945)
        cropTopConstraint = topConstraint(subView: cropView, constant: 0).priority(945)
        cropBottomConstraint = bottomConstraint(subView: cropView, constant: 0).priority(945)
        
        topConstraint(item: cropView,
                      subView: leftTopButton,
                      constant: 10)
        
        leadingConstraint(item: cropView,
                          subView: leftTopButton,
                          constant: 10)
        
        bottomConstraint(item: cropView,
                         subView: leftBottomButton,
                         constant: -10)
        
        leadingConstraint(item: cropView,
                          subView: leftBottomButton,
                          constant: 10)
        
        topConstraint(item: cropView,
                      subView: rightTopButton,
                      constant: 10)
        
        trailingConstraint(item: cropView,
                           subView: rightTopButton,
                           constant: -10)
        
        bottomConstraint(item: cropView,
                         subView: rightBottomButton,
                         constant: -10)
        
        trailingConstraint(item: cropView,
                           subView: rightBottomButton,
                           constant: -10)
        
        topConstraint(item: cropView,
                      subView: topButton,
                      constant: 10)
        
        centerXConstraint(item: cropView,
                          subView: topButton)
        
        centerYConstraint(item: cropView,
                          subView: leftButton)
        
        leadingConstraint(item: cropView,
                          subView: leftButton,
                          constant: 10)
        
        centerYConstraint(item: cropView,
                          subView: rightButton)
        
        trailingConstraint(item: cropView,
                           subView: rightButton,
                           constant: -10)
        
        bottomConstraint(item: cropView,
                         subView: bottomButton,
                         constant: -10)
        
        centerXConstraint(item: cropView,
                          subView: bottomButton)
        
        centerButton.widthConstraint(constant: 80,
                                     relatedBy: .equal).priority = UILayoutPriority(700)
        
        centerButton.heightConstraint(constant: 80,
                                      relatedBy: .equal).priority = UILayoutPriority(700)
        
        centerXConstraint(item: cropView,
                          subView: centerButton)
        
        centerYConstraint(item: cropView,
                          subView: centerButton)
        
        let leading = NSLayoutConstraint(item: leftButton,
                                         attribute: .trailing,
                                         relatedBy: .greaterThanOrEqual,
                                         toItem: centerButton,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0)
        
        let trailing = NSLayoutConstraint(item: rightButton,
                                          attribute: .leading,
                                          relatedBy: .greaterThanOrEqual,
                                          toItem: centerButton,
                                          attribute: .trailing,
                                          multiplier: 1,
                                          constant: 0)
        
        let top = NSLayoutConstraint(item: topButton,
                                     attribute: .bottom,
                                     relatedBy: .greaterThanOrEqual,
                                     toItem: centerButton,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: 0)
        
        let bottom = NSLayoutConstraint(item: bottomButton,
                                        attribute: .top,
                                        relatedBy: .greaterThanOrEqual,
                                        toItem: centerButton,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        leading.priority = UILayoutPriority(600)
        trailing.priority = UILayoutPriority(600)
        top.priority = UILayoutPriority(600)
        bottom.priority = UILayoutPriority(600)
        
        addConstraints([leading,
                        trailing,
                        top,
                        bottom])
        
        scrollView.clipsToBounds = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        cropLineHidden(image)
        
        cropLineColor = cropLineColor ?? .white
        scrollMinimumZoomScale = 0.3
        scrollMaximumZoomScale = 5
        scrollBackgroundColor = scrollBackgroundColor ?? .black
        imageBackgroundColor = imageBackgroundColor ?? .black
        dimBackgroundColor = dimBackgroundColor ?? UIColor(white: 0, alpha: 0.6)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        lineButtonGroup.forEach { (button) in
            button.delegate = self
            button.addTarget(self, action: #selector(cropButtonTouchDown(_:forEvent:)), for: .touchDown)
            button.addTarget(self, action: #selector(cropButtonTouchUpInside(_:forEvent:)), for: .touchUpInside)
        }
        
        leftTopButton.addTarget(self,
                                action: #selector(cropButtonLeftTopDrag(_:forEvent:)),
                                for: .touchDragInside)
        
        leftBottomButton.addTarget(self,
                                   action: #selector(cropButtonLeftBottomDrag(_:forEvent:)),
                                   for: .touchDragInside)
        
        rightTopButton.addTarget(self,
                                 action: #selector(cropButtonRightTopDrag(_:forEvent:)),
                                 for: .touchDragInside)
        
        rightBottomButton.addTarget(self,
                                    action: #selector(cropButtonRightBottomDrag(_:forEvent:)),
                                    for: .touchDragInside)
        
        topButton.addTarget(self,
                            action: #selector(cropButtonTopDrag(_:forEvent:)),
                            for: .touchDragInside)
        
        leftButton.addTarget(self,
                             action: #selector(cropButtonLeftDrag(_:forEvent:)),
                             for: .touchDragInside)
        
        rightButton.addTarget(self,
                              action: #selector(cropButtonRightDrag(_:forEvent:)),
                              for: .touchDragInside)
        
        bottomButton.addTarget(self,
                               action: #selector(cropButtonBottomDrag(_:forEvent:)),
                               for: .touchDragInside)
        
        centerButton.addTarget(self,
                               action: #selector(centerDoubleTap(_:)),
                               for: .touchDownRepeat)
        
        centerButton.addTarget(self,
                               action: #selector(cropButtonCenterDrag(_:forEvent:)),
                               for: .touchDragInside)
        
        if isRate {
            topButton.isHidden = true
            leftButton.isHidden = true
            bottomButton.isHidden = true
            rightButton.isHidden = true
        }
        
        layoutIfNeeded()
    }
    
    // Does not display lines when the image is nil.
    private func cropLineHidden(_ image: UIImage?) {
        cropView.alpha = image == nil ? 0 : 1
        leftTopButton.alpha = image == nil ? 0 : 1
        leftBottomButton.alpha = image == nil ? 0 : 1
        rightBottomButton.alpha = image == nil ? 0 : 1
        rightTopButton.alpha = image == nil ? 0 : 1
        topButton.alpha = image == nil ? 0 : 1
        bottomButton.alpha = image == nil ? 0 : 1
        leftButton.alpha = image == nil ? 0 : 1
        rightButton.alpha = image == nil ? 0 : 1
    }
}


//MARK: ScrollViewDelegate Methods

extension ImageCropView: UIScrollViewDelegate {
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if scrollView.zoomScale <= 1 {
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
            
        } else {
            
            let imageSize = imageView.frameForImageInImageViewAspectFit
            if isImageRateHeightGreaterThan(imageSize) {
                
                let imageOffset = -imageSize.origin.y
                let scrollOffset = (scrollView.bounds.height - scrollView.contentSize.height) * 0.5
                if imageOffset > scrollOffset {
                    scrollView.contentInset = UIEdgeInsets(top: imageOffset,
                                                           left: 0, bottom: imageOffset,
                                                           right: 0)
                } else {
                    
                    scrollView.contentInset = UIEdgeInsets(top: scrollOffset,
                                                           left: 0,
                                                           bottom: scrollOffset,
                                                           right: 0)
                }
                
            } else {
                
                let imageOffset = -imageSize.origin.x
                let scrollOffset = (scrollView.bounds.width - scrollView.contentSize.width) * 0.5
                
                if imageOffset > scrollOffset {
                    
                    scrollView.contentInset = UIEdgeInsets(top: 0,
                                                           left: imageOffset,
                                                           bottom: 0,
                                                           right: imageOffset)
                } else {
                    scrollView.contentInset = UIEdgeInsets(top: 0,
                                                           left: scrollOffset,
                                                           bottom: 0,
                                                           right: scrollOffset)
                }
            }
        }
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}


// MARK: Private Method Crop

extension ImageCropView {
    private func isImageRateHeightGreaterThan(_ imageSize: CGRect) -> Bool {
        let widthRate =  bounds.width / imageSize.width
        let heightRate = bounds.height / imageSize.height
        return widthRate < heightRate
    }
}

// MARK: Private Method Dim

extension ImageCropView {
    // Modify the dim screen mask.
    func dimLayerMask(_ duration: TimeInterval = 0.4, animated: Bool) {
        guard let cropLeadingConstraint = self.cropLeadingConstraint,
            let cropTrailingConstraint = self.cropTrailingConstraint,
            let cropTopConstraint = self.cropTopConstraint,
            let cropBottomConstraint = self.cropBottomConstraint else { return }
        
        let width = self.scrollView.bounds.width - (-cropLeadingConstraint.constant + cropTrailingConstraint.constant)
        let height = self.scrollView.bounds.height - (-cropTopConstraint.constant + cropBottomConstraint.constant)
      

        for constraint in self.leftButton.constraints where constraint.firstAttribute == .height {
            constraint.constant = height - 100.0
        }
        for constraint in self.rightButton.constraints where constraint.firstAttribute == .height {
            constraint.constant = height - 100.0
        }
        for constraint in self.topButton.constraints where constraint.firstAttribute == .width {
            constraint.constant = width - 100.0
        }
        for constraint in self.bottomButton.constraints where constraint.firstAttribute == .width {
            constraint.constant = width - 100.0
        }
        
        self.dimView.layoutIfNeeded()
        
        let path = UIBezierPath(rect: CGRect(
            x: -cropLeadingConstraint.constant,
            y: -cropTopConstraint.constant,
            width: width,
            height: height
        ))
        path.append(UIBezierPath(rect: self.dimView.bounds))
        
        self.dimView.mask(path.cgPath,
                          duration: duration,
                          animated: animated)
    }
}

//MARK:  Crop LineView

// Crop LineView
public class CropView: UIView {
    private let margin: CGFloat = 0
    private let lineSize: CGFloat = 1
    
    var lineColor: UIColor? = .white {
        willSet {
            topLineView.backgroundColor = newValue
            bottomLineView.backgroundColor = newValue
            leftLineView.backgroundColor = newValue
            rightLineView.backgroundColor = newValue
            horizontalRightLineView.backgroundColor = newValue
            horizontalLeftLineView.backgroundColor = newValue
            verticalTopLineView.backgroundColor = newValue
            verticalBottomLineView.backgroundColor = newValue
        }
    }
    
    public let topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let leftLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let rightLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalLeftLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalRightLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalTopLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalLeftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalCenterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let horizontalRightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalCenterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let verticalBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        initVars()
    }
    
    init() {
        super.init(frame: .zero)
        
        initVars()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initVars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initVars() {
        
        addSubview(topLineView)
        addSubview(leftLineView)
        addSubview(bottomLineView)
        addSubview(rightLineView)
        addSubview(horizontalLeftLineView)
        addSubview(horizontalRightLineView)
        addSubview(verticalTopLineView)
        addSubview(verticalBottomLineView)
        addSubview(horizontalLeftView)
        addSubview(horizontalCenterView)
        addSubview(horizontalRightView)
        addSubview(verticalTopView)
        addSubview(verticalCenterView)
        addSubview(verticalBottomView)

        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: topLineView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: topLineView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: topLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        topLineView.addConstraint(NSLayoutConstraint(item: topLineView,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .height,
                                                     multiplier: 1,
                                                     constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: leftLineView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: leftLineView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: leftLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        leftLineView.addConstraint(NSLayoutConstraint(item: leftLineView,
                                                      attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .width,
                                                      multiplier: 1,
                                                      constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: bottomLineView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: bottomLineView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: bottomLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        bottomLineView.addConstraint(NSLayoutConstraint(item: bottomLineView,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .height,
                                                        multiplier: 1,
                                                        constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: rightLineView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: rightLineView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: rightLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: margin).priority(950))
        
        rightLineView.addConstraint(NSLayoutConstraint(item: rightLineView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .width,
                                                       multiplier: 1,
                                                       constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalLeftView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: horizontalLeftLineView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: bottomLineView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: horizontalLeftLineView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: topLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: horizontalLeftLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        horizontalLeftLineView.addConstraint(NSLayoutConstraint(item: horizontalLeftLineView,
                                                                attribute: .width,
                                                                relatedBy: .equal,
                                                                toItem: nil,
                                                                attribute: .width,
                                                                multiplier: 1,
                                                                constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalCenterView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: horizontalRightLineView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: bottomLineView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: horizontalRightLineView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: topLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: horizontalRightLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        horizontalRightLineView.addConstraint(NSLayoutConstraint(item: horizontalRightLineView,
                                                                 attribute: .width,
                                                                 relatedBy: .equal,
                                                                 toItem: nil,
                                                                 attribute: .width,
                                                                 multiplier: 1,
                                                                 constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalTopView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: verticalTopLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: leftLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: verticalTopLineView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: rightLineView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: verticalTopLineView,
                                         attribute: .trailing,
                                         multiplier: 1, constant: 0).priority(950))
        
        verticalTopLineView.addConstraint(NSLayoutConstraint(item: verticalTopLineView,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: nil,
                                                             attribute: .height,
                                                             multiplier: 1,
                                                             constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalCenterView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: verticalBottomLineView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: leftLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: verticalBottomLineView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: rightLineView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: verticalBottomLineView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        verticalBottomLineView.addConstraint(NSLayoutConstraint(item: verticalBottomLineView,
                                                                attribute: .height,
                                                                relatedBy: .equal,
                                                                toItem: nil,
                                                                attribute: .height,
                                                                multiplier: 1,
                                                                constant: lineSize).priority(950))
        
        addConstraint(NSLayoutConstraint(item: leftLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: horizontalLeftView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: bottomLineView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: horizontalLeftView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: topLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: horizontalLeftView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalLeftLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: horizontalCenterView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: bottomLineView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: horizontalCenterView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: topLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: horizontalCenterView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalLeftView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: horizontalCenterView,
                                         attribute: .width,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalRightLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: horizontalRightView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: bottomLineView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: horizontalRightView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: topLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: horizontalRightView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: rightLineView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: horizontalRightView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: horizontalLeftView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: horizontalRightView,
                                         attribute: .width,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: topLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: verticalTopView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: leftLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: verticalTopView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: rightLineView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: verticalTopView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalTopLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: verticalCenterView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
    
        addConstraint(NSLayoutConstraint(item: leftLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: verticalCenterView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: rightLineView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: verticalCenterView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalTopView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: verticalCenterView,
                                         attribute: .height,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalBottomLineView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: verticalBottomView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: leftLineView,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: verticalBottomView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: rightLineView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: verticalBottomView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: verticalTopView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: verticalBottomView,
                                         attribute: .height,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        addConstraint(NSLayoutConstraint(item: bottomLineView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: verticalBottomView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0).priority(950))
        
        isUserInteractionEnabled = false
        backgroundColor = .clear
        topLineView.alpha = 1
        leftLineView.alpha = 1
        bottomLineView.alpha = 1
        rightLineView.alpha = 1
        horizontalLeftLineView.alpha = 0
        horizontalRightLineView.alpha = 0
        verticalTopLineView.alpha = 0
        verticalBottomLineView.alpha = 0
        
        horizontalLeftView.alpha = 0
        horizontalCenterView.alpha = 0
        horizontalRightView.alpha = 0
        verticalTopView.alpha = 0
        verticalCenterView.alpha = 0
        verticalBottomView.alpha = 0
    }
    
    func line(_ isHidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                
                if isHidden {
                    self.horizontalRightLineView.alpha = 0
                    self.horizontalLeftLineView.alpha = 0
                    self.verticalTopLineView.alpha = 0
                    self.verticalBottomLineView.alpha = 0
                } else {
                    self.horizontalRightLineView.alpha = 1
                    self.horizontalLeftLineView.alpha = 1
                    self.verticalTopLineView.alpha = 1
                    self.verticalBottomLineView.alpha = 1
                }
            }
            
        } else {
            
            if isHidden {
                horizontalRightLineView.alpha = 0
                horizontalLeftLineView.alpha = 0
                verticalTopLineView.alpha = 0
                verticalBottomLineView.alpha = 0
            } else {
                horizontalRightLineView.alpha = 1
                horizontalLeftLineView.alpha = 1
                verticalTopLineView.alpha = 1
                verticalBottomLineView.alpha = 1
            }
        }
    }
}

// CropDimView
class CropDimView: UIView {
    var path: CGPath?
    
    init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func mask(_ path: CGPath, duration: TimeInterval, animated: Bool) {
        
        self.path = path
        if let mask = self.layer.mask as? CAShapeLayer {
            mask.removeAllAnimations()
            
            if animated {
                let animation = CABasicAnimation(keyPath: "path")
                animation.delegate = self
                animation.fromValue = mask.path
                animation.toValue = path
                animation.byValue = path
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                animation.duration = duration
                mask.add(animation, forKey: "path")
                
            } else {
                mask.path = path
            }
            
        } else {
            
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.path = path
            self.layer.mask = maskLayer
        }
    }
}

// MARK: Private Method Touch Action

extension ImageCropView {
    // Center Button Double Tap
    @objc private func centerDoubleTap(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.imageDoubleTap(sender)
        }
    }
    
    // ImageView Double Tap
    @objc private func imageDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            imageRealSize(true)
            DispatchQueue.main.async {
                self.imageMaxAdjustment(animated: true)
            }
        } else {
            scrollView.setZoomScale(1, animated: true)
            DispatchQueue.main.async {
                self.imageMinAdjustment(animated: true)
            }
        }
    }
    
    // Touch Down Button
    @objc private func cropButtonTouchDown(_ sender: LineButton, forEvent event: UIEvent) {
        guard let touch = event.touches(for: sender)?.first else { return }
        lineButtonTouchPoint = touch.location(in: self)
        cropView.line(false, animated: true)
        dimLayerMask(animated: false)
        lineButtonGroup
            .filter { sender != $0 }
            .forEach { $0.isUserInteractionEnabled = false }
    }
    
    
    // Touch Up Inside Button
    @objc private func cropButtonTouchUpInside(_ sender: LineButton, forEvent event: UIEvent) {
        
        lineButtonTouchPoint = nil
        cropView.line(true, animated: true)
        dimLayerMask(animated: false)
        lineButtonGroup
            .forEach { $0.isUserInteractionEnabled = true }
    }
    
    @objc private func cropButtonLeftTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        if isRate {
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width + hConstant - cropTrailingConstraint.constant
                let vConstant = bounds.height - cropBottomConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant - cropBottomConstraint.constant
                if (-hConstant) >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    self.cropLeadingConstraint?.constant = hConstant
                    self.cropTopConstraint?.constant = -vConstant
                }
                
            } else {
                
                let height = bounds.height + vConstant - cropBottomConstraint.constant
                let hConstant = bounds.width - cropTrailingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant - cropTrailingConstraint.constant
                if hConstant >= 0 && (-vConstant) >= 0 && height > cropMinSize && width > cropMinSize {
                    self.cropTopConstraint?.constant = vConstant
                    self.cropLeadingConstraint?.constant = -hConstant
                }
            }
            
        } else {
            
            if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && bounds.width + (hConstant - cropTrailingConstraint.constant) > cropMinSize {
                self.cropLeadingConstraint?.constant = hConstant
            }
            if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && bounds.height + (vConstant - cropBottomConstraint.constant) > cropMinSize {
                self.cropTopConstraint?.constant = vConstant
            }
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonLeftBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }

        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if isRate {
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width + hConstant - cropTrailingConstraint.constant
                let vConstant = bounds.height + cropTopConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant + cropTopConstraint.constant
                if (-hConstant) >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    
                    self.cropLeadingConstraint?.constant = hConstant
                    self.cropBottomConstraint?.constant = vConstant
                }
                
            } else {
                
                let height = bounds.height - vConstant + cropTopConstraint.constant
                let hConstant = bounds.width - cropTrailingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant - cropTrailingConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && height > cropMinSize && width > cropMinSize {
                    
                    self.cropBottomConstraint?.constant = vConstant
                    self.cropLeadingConstraint?.constant = -hConstant
                }
            }
            
        } else {
            
            if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && bounds.width + (hConstant - cropTrailingConstraint.constant) > cropMinSize {
                self.cropLeadingConstraint?.constant = hConstant
            }
            if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && bounds.height - (vConstant - cropTopConstraint.constant) > cropMinSize {
                self.cropBottomConstraint?.constant = vConstant
            }
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.x = currentPoint.x
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if isRate {
            
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                let vConstant = bounds.height - cropBottomConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant - cropBottomConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    
                    self.cropTrailingConstraint?.constant = hConstant
                    self.cropTopConstraint?.constant = -vConstant
                }
                
            } else {
                
                let height = bounds.height + vConstant - cropBottomConstraint.constant
                let hConstant = bounds.width + cropLeadingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                if hConstant >= 0 && (-vConstant) >= 0 && height > cropMinSize && width > cropMinSize {
                    
                    self.cropTopConstraint?.constant = vConstant
                    self.cropTrailingConstraint?.constant = hConstant
                }
            }
            
        } else {
            
            if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && bounds.width - (hConstant - cropLeadingConstraint.constant) > cropMinSize {
                self.cropTrailingConstraint?.constant = hConstant
            }
            if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && bounds.height + (vConstant - cropBottomConstraint.constant) > cropMinSize {
                self.cropTopConstraint?.constant = vConstant
            }
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.x = currentPoint.x
        lineButtonTouchPoint?.y = currentPoint.y
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        
        if isRate {
            let xMargin = touchPoint.x - currentPoint.x
            let yMargin = touchPoint.y - currentPoint.y
            if abs(xMargin) > abs(yMargin) {
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                let vConstant = bounds.height + cropTopConstraint.constant - (width / aspectRatio)
                let height = bounds.height - vConstant + cropTopConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && width > cropMinSize && height > cropMinSize {
                    self.cropTrailingConstraint?.constant = hConstant
                    self.cropBottomConstraint?.constant = vConstant
                }
                
            } else {
                
                let height = bounds.height - vConstant + cropTopConstraint.constant
                let hConstant = bounds.width + cropLeadingConstraint.constant - (height * aspectRatio)
                let width = bounds.width - hConstant + cropLeadingConstraint.constant
                if hConstant >= 0 && vConstant >= 0 && height > cropMinSize && width > cropMinSize {
                    self.cropBottomConstraint?.constant = vConstant
                    self.cropTrailingConstraint?.constant = hConstant
                }
            }
            
        } else {
            
            if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && bounds.width - (hConstant - cropLeadingConstraint.constant) > cropMinSize {
                self.cropTrailingConstraint?.constant = hConstant
            }
            if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && bounds.height - (vConstant - cropTopConstraint.constant) > cropMinSize {
                self.cropBottomConstraint?.constant = vConstant
            }
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonLeftDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let hConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (hConstant <= 0 || currentPoint.x - touchPoint.x > 0) && bounds.width + (hConstant - cropTrailingConstraint.constant) > cropMinSize {
            self.cropLeadingConstraint?.constant = hConstant
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonTopDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let vConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        if (vConstant <= 0 || currentPoint.y - touchPoint.y > 0) && bounds.height + (vConstant - cropBottomConstraint.constant) > cropMinSize {
            self.cropTopConstraint?.constant = vConstant
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonRightDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.x = currentPoint.x
        
        let hConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (hConstant > 0 || currentPoint.x - touchPoint.x < 0) && bounds.width - (hConstant - cropLeadingConstraint.constant) > cropMinSize {
            self.cropTrailingConstraint?.constant = hConstant
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonBottomDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropTopConstraint =  cropTopConstraint,
            let cropBottomConstraint =  cropBottomConstraint else { return }
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        lineButtonTouchPoint?.y = currentPoint.y
        
        let vConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        if (vConstant > 0 || currentPoint.y - touchPoint.y < 0) && bounds.height - (vConstant - cropTopConstraint.constant) > cropMinSize {
            self.cropBottomConstraint?.constant = vConstant
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
    
    @objc private func cropButtonCenterDrag(_ sender: LineButton, forEvent event: UIEvent) {
        
        guard let cropLeadingConstraint = cropLeadingConstraint,
            let cropTrailingConstraint = cropTrailingConstraint,
            let cropTopConstraint = cropTopConstraint,
            let cropBottomConstraint = cropBottomConstraint else { return }
        
        guard let touchPoint = lineButtonTouchPoint,
                let currentPoint = event.touches(for: sender)?.first?.location(in: self) else { return }
        
        let lConstant = cropLeadingConstraint.constant - (currentPoint.x - touchPoint.x)
        let rConstant = cropTrailingConstraint.constant - (currentPoint.x - touchPoint.x)
        
        if (lConstant <= 0 || currentPoint.x - touchPoint.x > 0) &&
            (rConstant > 0 || currentPoint.x - touchPoint.x < 0) {
            self.cropLeadingConstraint?.constant = lConstant
            self.cropTrailingConstraint?.constant = rConstant
        }
        
        let tConstant = cropTopConstraint.constant - (currentPoint.y - touchPoint.y)
        let bConstant = cropBottomConstraint.constant - (currentPoint.y - touchPoint.y)
        if (tConstant <= 0 || currentPoint.y - touchPoint.y > 0) &&
            (bConstant > 0 || currentPoint.y - touchPoint.y < 0) {
            self.cropTopConstraint?.constant = tConstant
            self.cropBottomConstraint?.constant = bConstant
        }
        
        lineButtonTouchPoint = currentPoint
        dimLayerMask(animated: false)
    }
}

// MARK: CAAnimationDelegate
extension CropDimView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let path = self.path else { return }
        if let mask = self.layer.mask as? CAShapeLayer {
            mask.removeAllAnimations()
            mask.path = path
        }
    }
}

// MARK: LineButtonDelegate
extension ImageCropView: LineButtonDelegate {
    
    // When highlighted on the line button disappears, Enable interaction for all buttons.
    func lineButtonUnHighlighted() {
        self.lineButtonTouchPoint = nil
        self.cropView.line(true, animated: true)
        self.dimLayerMask(animated: false)
        self.lineButtonGroup
            .forEach { $0.isUserInteractionEnabled = true }
    }
}

// Called when the button's highlighted is false.
protocol LineButtonDelegate: AnyObject {
    func lineButtonUnHighlighted()
}

// MARK: Side, Edge LineButton

public class LineButton: UIButton {
    weak var delegate: LineButtonDelegate?
    
    private var type: ButtonLineType
    
    public override var isHighlighted: Bool {
        didSet {
            if !isHighlighted {
                delegate?.lineButtonUnHighlighted()
            }
        }
    }
    
    // MARK: Init
    
    init(_ type: ButtonLineType) {
        self.type = type
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        setTitle(nil, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        if type != .center {
            widthConstraint(constant: 50)
            heightConstraint(constant: 50)
            alpha = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func edgeLine(_ color: UIColor?) {
        setImage(type.view(color)?.imageWithView?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

// Enum buttonLineType:

enum ButtonLineType {
    case center
    case leftTop,
         rightTop,
         leftBottom,
         rightBottom,
         top,
         left,
         right,
         bottom
    
    var rotate: CGFloat {
        switch self {
        case .leftTop:
            return 0
        case .rightTop:
            return CGFloat.pi/2
        case .rightBottom:
            return CGFloat.pi
        case .leftBottom:
            return CGFloat.pi/2*3
        case .top:
            return 0
        case .left:
            return CGFloat.pi/2*3
        case .right:
            return CGFloat.pi/2
        case .bottom:
            return CGFloat.pi
        case .center:
            return 0
        }
    }
    
    var yMargin: CGFloat {
        switch self {
        case .rightBottom, .bottom:
            return 1
        default:
            return 0
        }
    }
    
    var xMargin: CGFloat {
        switch self {
        case .leftBottom:
            return 1
        default:
            return 0
        }
    }
    
    func view(_ color: UIColor?) -> UIView? {
        var view: UIView?
        if self == .leftTop || self == .rightTop || self == .leftBottom || self == .rightBottom {
            view = ButtonLineType.EdgeView(self, color: color)
        } else {
            view = ButtonLineType.SideView(self, color: color)
        }
        view?.isOpaque = false
        view?.tintColor = color
        return view
    }
    
    class LineView: UIView {
        var type: ButtonLineType
        var color: UIColor?
        init(_ type: ButtonLineType, color: UIColor?) {
            self.type = type
            self.color = color
            super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func apply(_ path: UIBezierPath) {
            var pathTransform  = CGAffineTransform.identity
            pathTransform = pathTransform.translatedBy(x: 25, y: 25)
            pathTransform = pathTransform.rotated(by: type.rotate)
            pathTransform = pathTransform.translatedBy(x: -25 - type.xMargin, y: -25 - type.yMargin)
            path.apply(pathTransform)
            path.closed()
                .strokeFill(.white)
        }
    }
    
    class EdgeView: LineView {
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
                .move(6, 6)
                .line(6, 20)
                .line(8, 20)
                .line(8, 8)
                .line(20, 8)
                .line(20, 6)
                .line(6, 6)
            apply(path)
        }
    }
    
    class SideView: LineView {
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
                .move(15, 6)
                .line(35, 6)
                .line(35, 8)
                .line(15, 8)
                .line(15, 6)
            apply(path)
        }
    }
}
