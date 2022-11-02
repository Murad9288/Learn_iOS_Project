//
//  ViewController.swift
//  Clean_Test_App
//
//  Created by Md Murad Hossain on 1/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var photoview: UIView!
    @IBOutlet weak var cotractView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    //@IBOutlet weak var photoImage: UIImageView!
    
    //@IBOutlet weak var contractImage: UIImageView!
    
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var ptextView: UIView!
    
    @IBOutlet weak var ctextView: UIView!
    
    @IBOutlet weak var vtextView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        allviewradius()
        
        whiteView.layer.cornerRadius = whiteView.frame.size.width / 2
        
    }
    func allviewradius(){
        photoview.layer.cornerRadius = 10
        cotractView.layer.cornerRadius = 10
        videoView.layer.cornerRadius = 10
        //photoImage.layer.cornerRadius = 10
        //contractImage.layer.cornerRadius = 10
        videoImage.layer.cornerRadius = 10
        ptextView.layer.cornerRadius = 10
        ctextView.layer.cornerRadius = 10
        vtextView.layer.cornerRadius = 10
    }
    
    func setupSlider(){
        // init slider view
        let frame = CGRect(x: 16, y: -28, width: circleView.frame.width-33, height: circleView.frame.height+100)
        let circularSlider = CircularSlider(frame: frame)
        
    
        
        // setup target to watch for value change
        //circularSlider.addTarget(self, action: #selector(MainEditViewController.valueChanged(_:)), for: UIControl.Event.valueChanged)
        
        // setup slider defaults
        circularSlider.maximumAngle = 280
        circularSlider.unfilledArcLineCap = .round
        circularSlider.filledArcLineCap = .round
        circularSlider.handleType = .bigCircle
        circularSlider.currentValue = 79
        circularSlider.lineWidth = 20
        circularSlider.labelDisplacement = -10
        circularSlider.isUserInteractionEnabled = true
        //circularSlider.innerMarkingLabels = ["0.0", "1.0", "2.0", "3.0", "4.0", "5.0"]
        
        // add to view
        circleView.addSubview(circularSlider)
        // NOTE: create and set a transform to rotate the arc so the white space is centered at the bottom
        circularSlider.transform = circularSlider.getRotationalTransform()
    }


}

