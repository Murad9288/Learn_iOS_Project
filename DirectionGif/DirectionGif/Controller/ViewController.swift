//
//  ViewController.swift
//  DirectionGif
//
//  Created by Md Murad Hossain on 18/1/23.
//

import UIKit

class ViewController: UIViewController {

    let imageNames = ["1", "2", "3","4","5","6","7"]
    var index = 0
    var timer: Timer!

    @IBOutlet weak var imageView: UIImageView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "1")
        
    }
    
    @objc func loop() {
        if index != imageNames.count - 1 {
            index += 1
            changeImageLeft(index: index)
        } else {
            index = 0
            changeImageLeft(index: index)
        }
    }
    
    @objc func loopRight() {
        var index2 = imageNames.count
        if index2 != 7 {
            index2 -= 1
            changeImageRight(index: index2)
        }else {
            index2 = 0
            changeImageRight(index: index2)
        }
    }
    
    func changeImageLeft(index: Int) {
        UIView.transition(with: self.imageView,
                          duration: 0,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = UIImage(named: self.imageNames[index])
        }, completion: nil)
    }
    
    func changeImageRight(index: Int) {
        UIView.transition(with: self.imageView,
                          duration: 0,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = UIImage(named: self.imageNames[index])
        }, completion: nil)
    }
    
    @IBAction func leftDirectionButton(_ sender: UIButton) {
        timer =  Timer.scheduledTimer(timeInterval: 0.5,
                                      target: self,
                                      selector: #selector(self.loop),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @IBAction func loopDirectionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func rightDirectionButton(_ sender: UIButton) {
        timer =  Timer.scheduledTimer(timeInterval: 0.5,
                                      target: self,
                                      selector: #selector(self.loopRight),
                                      userInfo: nil,
                                      repeats: true)
    }
    
}
