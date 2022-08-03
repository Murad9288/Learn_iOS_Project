//
//  ViewController.swift
//  TestingApp
//
//  Created by Md Hosne Mobarok on 5/7/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Private Method.
    
    // MARK: - Button Action.
    @IBAction func aboutButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "About", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutViewControllerID") as! AboutViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

