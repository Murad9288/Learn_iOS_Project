//
//  AddDataViewController.swift
//  TodoList
//
//  Created by Md Murad Hossain on 11/10/22.
//

import UIKit

class AddDataViewController: UIViewController {

    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Button action
    //
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        
        
    }
    
    @IBAction func selectImageButtonAction(_ sender: UIButton){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
   
}


extension AddDataViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
