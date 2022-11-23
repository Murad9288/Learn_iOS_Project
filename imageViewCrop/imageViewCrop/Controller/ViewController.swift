//
//  ViewController.swift
//  imageViewCrop
//
//  Created by Md Murad Hossain on 19/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var imageCropView: ImageCropView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initialiseCropView()
    }
    
    func initialiseCropView() {
        guard let image = UIImage(named: "26") else {return}
        deInitialiseCropView()
        imageCropView = ImageCropView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: cropView.frame.size.width,
                                                    height: cropView.frame.size.height))
        cropView.addSubview(imageCropView!)
        imageCropView?.image = image
    }
    
    func deInitialiseCropView() {
        imageCropView?.removeFromSuperview()
        imageCropView = nil
    }

    @IBAction func resetHome(_ sender: UIButton){
        self.initialiseCropView()
    }
    @IBAction func CropButton(_ sender: UIButton){
        imageCropView?.crop { (error, image) in
            if (error as NSError?) != nil {
                print("Handle error here")
            }
            self.imageView.image = image
        }
    }

}

extension ViewController: CropPickerViewDelegate {
    
    internal func cropPickerView(_ cropPickerView: ImageCropView, didChange frame: CGRect) {
        
    }
}

