//
//  ImageViewController.swift
//  MultiplePhotos
//
//  Created by Md Murad Hossain on 18/10/22.
// email: muradhossainm01@gmail.com

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedImageView.image = selectedImage
        
        // MARK: Transform image primary state
        selectedImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
    }
    
    // MARK: Transform image view loded state
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.4){
            self.selectedImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
//   MARK: Setup ScrollView
    
    func setupScrollView(){
        scrollView.delegate = self
    }
}


// MARK: ScrollView Delegate Method and Zomming image

extension ImageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return selectedImageView
    }
}

// MARK: Code Finished

