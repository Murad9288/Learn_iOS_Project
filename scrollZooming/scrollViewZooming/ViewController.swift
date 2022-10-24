//
//  ViewController.swift
//  scrollViewZooming
//
//  Created by Md Murad Hossain on 19/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        
    }
    func setupScrollView(){
        scrollView.delegate = self
    }
    

}
extension ViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

