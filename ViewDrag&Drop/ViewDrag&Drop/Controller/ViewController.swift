//
//  ViewController.swift
//  ViewDrag&Drop
//
//  Created by Md Murad Hossain on 21/11/22.
//

import UIKit

class ViewController: UIViewController {

    

    let myView = UIView(frame: CGRect(x: 0,
                                      y: 0,
                                      width: 380,
                                      height: 380)
    )
    
    let myView2 = UIView(frame: CGRect(x: 0,
                                       y: 0,
                                       width: 150,
                                       height: 150)
    )

    
    //let imageView = UIImageView(image: UIImage(named: "m2")!)
    
    var isDraging =  false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myViewConfig()
        view2Config()
        
    }
    
//    MARK: View Configuration
    
    func myViewConfig() {
        
        myView.backgroundColor = .cyan
        myView.center = view.center
        view.addSubview(myView)
    }
    
    
    func view2Config() {

        myView2.backgroundColor = .orange
        myView2.center = view.center
        view.addSubview(myView2)

    }
    
}

// MARK: View Drag and Drop setup

extension ViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: myView2)
        if myView2.bounds.contains(location) {
            isDraging = true
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraging, let touch = touches.first else {
            return
        }
        let location = touch.location(in: view)

        myView2.frame.origin.x = location.x - (myView2.frame.size.width/2)
        myView2.frame.origin.y = location.y - (myView2.frame.size.height/2)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDraging = false


    }
}





