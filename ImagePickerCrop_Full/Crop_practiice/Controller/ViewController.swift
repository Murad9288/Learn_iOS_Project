//
//  ViewController.swift
//  ImagePickerCrop_Full
//
//  Created by Md Murad Hossain on 15/11/22.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet private weak var containerViewCrop: UIView!
    @IBOutlet private weak var radianController: UISlider!
    @IBOutlet private weak var ratioSegmentController: UISegmentedControl!

    @IBOutlet private weak var resultImageV: UIImageView!
    
    //@IBOutlet private weak var resultLabel: UILabel!

    
    let cropPickerView: ImageCropView = {
        let cropPickerView = ImageCropView()
        cropPickerView.translatesAutoresizingMaskIntoConstraints = false
        cropPickerView.backgroundColor = .black
        return cropPickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.containerViewCrop.addSubview(self.cropPickerView)
         
        self.containerViewCrop.addConstraints([
            NSLayoutConstraint(item: self.containerViewCrop!, attribute: .top, relatedBy: .equal, toItem: self.cropPickerView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerViewCrop!, attribute: .bottom, relatedBy: .equal, toItem: self.cropPickerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerViewCrop!, attribute: .leading, relatedBy: .equal, toItem: self.cropPickerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.containerViewCrop!, attribute: .trailing, relatedBy: .equal, toItem: self.cropPickerView, attribute: .trailing, multiplier: 1, constant: 0)
        ])

        self.cropPickerView.delegate = self

        DispatchQueue.main.async {
            self.cropPickerView.image(UIImage(named: "29.png"))
        }
        
        //        self.cropPickerView.image = image
        //        self.cropPickerView.image(image, crop: CGRect(x: 50, y: 30, width: 100, height: 80), isRealCropRect: false)
        //        self.cropPickerView.image(image, crop: CGRect(x: 50, y: 30, width: 100, height: 80), isRealCropRect: true)
        //        self.cropPickerView.image(image, isMin: false, crop: CGRect(x: 50, y: 30, width: 100, height: 80), isRealCropRect: true)
        //        self.cropPickerView.image(image, isMin: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        let button = UIButton(type: .system)
        button.setTitle("📷", for: .normal)
    
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        
        button.addTarget(self, action: #selector(self.albumTap(_:)), for: .touchUpInside)
        self.navigationItem.titleView = button

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.cropTap(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshTap(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func radianValueChanged(_ sender: UISlider) {
        self.cropPickerView.radius = CGFloat(sender.value)
    }

    @IBAction private func ratioValueChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.cropPickerView.aspectRatio = 0
            
        } else if sender.selectedSegmentIndex == 1 {
            self.cropPickerView.aspectRatio = 1
            
        } else if sender.selectedSegmentIndex == 2 {
            self.cropPickerView.aspectRatio = 1/2
            
        } else if sender.selectedSegmentIndex == 3 {
            self.cropPickerView.aspectRatio = 3/4
            
        } else if sender.selectedSegmentIndex == 4 {
            self.cropPickerView.aspectRatio = 4/3
        }
    }
    
    @objc func cropTap(_ sender: UIBarButtonItem) {
        self.cropPickerView.crop { (crop)  in
            self.resultImageV.image = crop.image
            
        // MARK: result label
            
//            self.resultLabel.text = ""
//            if let error = (crop.error as NSError?) {
//                self.resultLabel.text?.append("-error\n\(error.localizedDescription)(\(error.code))")
//            }
//            if let value = crop.cropFrame {
//                if self.resultLabel.text != "" {
//                    self.resultLabel.text?.append("\n\n")
//                }
//                self.resultLabel.text?.append("-crop frame\n\(value)")
//            }
//            if let value = crop.realCropFrame {
//                if self.resultLabel.text != "" {
//                    self.resultLabel.text?.append("\n\n")
//                }
//                self.resultLabel.text?.append("-real crop frame\n\(value)")
//            }
//            if let value = crop.imageSize {
//                if self.resultLabel.text != "" {
//                    self.resultLabel.text?.append("\n\n")
//                }
//                self.resultLabel.text?.append("-before image size\n\(value)")
//            }
        }
    }
    
    @objc func albumTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Choose your photos", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.modalPresentationStyle = .fullScreen
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Take photos", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    @objc func refreshTap(_ sender: UIBarButtonItem) {
        let image = UIImage(named: "\(Int.random(in: 21...33)).png")
        self.cropPickerView.image(image)
    }
}

// MARK: CropPickerViewDelegate

extension ViewController: CropPickerViewDelegate {
    
    func cropPickerView(_ cropPickerView: ImageCropView, result: CropResult) {

    }

    func cropPickerView(_ cropPickerView: ImageCropView, didChange frame: CGRect) {
        
        // MARK: Result label show
       // self.resultLabel.text = "\(frame)"
        
        let sliderValue = self.radianController.value
        self.radianController.maximumValue = frame.width > frame.height ? Float(frame.height / 2) : Float(frame.width / 2)
        if self.radianController.maximumValue < sliderValue {
            self.radianController.value = self.radianController.maximumValue
            self.cropPickerView.radius = CGFloat(self.radianController.value)
        }
    }
}

// MARK: UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UINavigationControllerDelegate

extension ViewController: UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        self.cropPickerView.image(image)
    }
}
