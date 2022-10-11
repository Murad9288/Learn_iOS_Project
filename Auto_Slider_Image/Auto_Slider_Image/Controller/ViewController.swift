//
//  ViewController.swift
//  Auto_Slider_Image
//
//  Created by Md Murad Hossain on 10/10/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var pagecontroller: UIPageControl!
    
    let imagarr = [
        UIImage(named: "1"),
        UIImage(named: "2"),
        UIImage(named: "3"),
        UIImage(named: "4")
    ]
    var time = Timer()
    var counter = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollection()
        setupPagecontrol()
    }

    // Mark: Action Button
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
        func collectionview(_ collectionview: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return imagarr.count
        }
    }
    
    
    
    
}

