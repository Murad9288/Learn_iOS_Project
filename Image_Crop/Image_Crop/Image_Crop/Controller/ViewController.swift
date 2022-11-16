//
//  ViewController.swift
//  Image_Crop
//
//  Created by Md Murad Hossain on 15/11/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var imageContainer: UIView!{
        didSet{
            imageContainer.backgroundColor = .clear
        }
    }
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    var imagePicker: ImagePickerViewController!
    
    private var cancelables: Set<AnyCancellable> = []
    
    var button: UIButton!
    
    var isCroping = false{
        didSet{
            button.setTitle(isCroping ? "Save Image" : "Pick Image", for: .normal)
        }
    }
    
    var cropBounds = CGRect()
    var croppingView: CroppableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        imagePicker = ImagePickerViewController()
    }

    @IBAction func pickImage(_ sender: Any) {
        button = sender as? UIButton
        
        if !isCroping{
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.delegate = self
            imagePicker.view.backgroundColor = .clear
            self.present(imagePicker, animated: true)
        }
        else{
            croppingView.hideAllSubviews = true
            let croppedImage = imageView.image(at: cropBounds)
            self.imageView.image = croppedImage
            self.saveImageToLib(image: croppedImage!)
            isCroping = false
        }
    }

    private func addCropperViewTo(view: UIView){
        croppingView = CroppableView(frame: view.frame)
        view.addSubview(croppingView)
        view.isUserInteractionEnabled = true
        
        croppingView.$cropBounds
            .sink { cropBounds in
                guard let crop = cropBounds else { return }
                print(crop)
                self.cropBounds = crop
            }
            .store(in: &cancelables)
    }
    
    private func saveImageToLib(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
       
    }
    
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
        }
    }
}

extension ViewController: ImagePickerControllerDelegate{
    func didDismissWithoutSelectingImage(_ viewController: ImagePickerViewController) {}
    
    func didSelectImage(_ selectedImageInfo: UserImageInfo) {
        imagePicker.dismiss(animated: true)
        imageView.image = selectedImageInfo.image
        addCropperViewTo(view: imageContainer)
        isCroping = true
    }
}

extension UIImage {
    func cropped(to cropRect: CGRect) -> UIImage?
    {
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = self.cgImage?.cropping(to:cropRect)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}

extension UIImageView {
    func image(at rect: CGRect) -> UIImage? {
        guard
            let image = image,
            let rect = convertToImageCoordinates(rect)
        else {
            return nil
        }

        return image.cropped(to: rect)
    }

    func convertToImageCoordinates(_ rect: CGRect) -> CGRect? {
        guard let image = image else { return nil }

        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        let imageCenter = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)

        let imageViewRatio = bounds.width / bounds.height
        let imageRatio = imageSize.width / imageSize.height

        let scale: CGPoint

        switch contentMode {
        case .scaleToFill:
            scale = CGPoint(x: imageSize.width / bounds.width, y: imageSize.height / bounds.height)

        case .scaleAspectFit:
            let value: CGFloat
            if imageRatio < imageViewRatio {
                value = imageSize.height / bounds.height
            } else {
                value = imageSize.width / bounds.width
            }
            scale = CGPoint(x: value, y: value)

        case .scaleAspectFill:
            let value: CGFloat
            if imageRatio > imageViewRatio {
                value = imageSize.height / bounds.height
            } else {
                value = imageSize.width / bounds.width
            }
            scale = CGPoint(x: value, y: value)

        case .center:
            scale = CGPoint(x: 1, y: 1)

        // unhandled cases include
        // case .redraw:
        // case .top:
        // case .bottom:
        // case .left:
        // case .right:
        // case .topLeft:
        // case .topRight:
        // case .bottomLeft:
        // case .bottomRight:

        default:
            fatalError("Unexpected contentMode")
        }

        var rect = rect
        if rect.width < 0 {
            rect.origin.x += rect.width
            rect.size.width = -rect.width
        }

        if rect.height < 0 {
            rect.origin.y += rect.height
            rect.size.height = -rect.height
        }

        return CGRect(x: (rect.minX - bounds.midX) * scale.x + imageCenter.x,
                      y: (rect.minY - bounds.midY) * scale.y + imageCenter.y,
                      width: rect.width * scale.x,
                      height: rect.height * scale.y)
    }
}
