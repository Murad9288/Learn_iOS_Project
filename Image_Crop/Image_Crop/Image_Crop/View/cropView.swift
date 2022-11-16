//
//  cropView.swift
//  Image_Crop
//
//  Created by Md Murad Hossain on 15/11/22.
//

import UIKit
import Combine
class CroppableView: UIView {
    
    struct CornerView {
        
        enum CornerPosition {
            case top
            case bottom
            case right
            case left
        }
        
        var position: CornerPosition
        
        var view: UIView = {
            let view = UIView()
            view.backgroundColor = .systemPink.withAlphaComponent(0.5)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    }

    private var rightView = CornerView(position: .right)
    private var leftView = CornerView(position: .left)
    private var topView = CornerView(position: .top)
    private var bottomView = CornerView(position: .bottom)
    
    @Published private(set) var cropBounds: CGRect! {
        didSet{
            moveAdjacentViews(to: cropBoundaryView, parent: self, movingViews: [topView, bottomView, leftView, rightView])
        }
    }
    
    var hideAllSubviews: Bool = false {
        didSet{
            topView.view.isHidden = hideAllSubviews
            bottomView.view.isHidden = hideAllSubviews
            rightView.view.isHidden = hideAllSubviews
            leftView.view.isHidden = hideAllSubviews
            cropBoundaryView.isHidden = hideAllSubviews
        }
    }
    
    private var cropBoundaryView: UIView! {
        didSet{
            cropBounds = cropBoundaryView.frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        //fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        isUserInteractionEnabled = true
        clipsToBounds = true
        addAdjacentViews()
        addGestures()
    }
    
    // Add adj view to moving view
    private func addAdjacentViews(){
        self.addSubview(rightView.view)
        self.addSubview(leftView.view)
        self.addSubview(topView.view)
        self.addSubview(bottomView.view)
    }
    
    // Move adj view with moving view
    private func moveAdjacentViews(to view: UIView, parent: UIView, movingViews: [CornerView]){
        movingViews.forEach{ movingView in
            switch movingView.position {
            case .top:
                NSLayoutConstraint.activate([movingView.view.topAnchor.constraint(equalTo: parent.topAnchor),
                                             movingView.view.bottomAnchor.constraint(equalTo: view.topAnchor),
                                             movingView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                             movingView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
            case .bottom:
                NSLayoutConstraint.activate([movingView.view.topAnchor.constraint(equalTo: view.bottomAnchor),
                                             movingView.view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
                                             movingView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                             movingView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
            case .right:
                NSLayoutConstraint.activate([movingView.view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                                             movingView.view.trailingAnchor.constraint(equalTo: view.leadingAnchor),
                                             movingView.view.heightAnchor.constraint(equalTo: parent.heightAnchor)])
            case .left:
                NSLayoutConstraint.activate([movingView.view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                                             movingView.view.leadingAnchor.constraint(equalTo: view.trailingAnchor),
                                             movingView.view.heightAnchor.constraint(equalTo: parent.heightAnchor)])
            }
        }
    }
    
    private func addGestures(){
        cropBoundaryView = addResizGestureViewTo(view: self)
        addDragGestureViewTo(view: cropBoundaryView)
    }
    
    private func addResizGestureViewTo(view parent: UIView) -> UIView {
        let resizeView = UIView()
        resizeView.frame.origin = .zero
        resizeView.frame.size = parent.frame.size //bounds.size
        resizeView.layer.borderColor = UIColor.clear.cgColor //UIColor.yellow.cgColor
        resizeView.layer.borderWidth = 1.0
        parent.addSubview(resizeView)
        
        resizeView.addCustomShapeBorderLayers()
        // Resize Pan Gesture
        let resizePanGesture = UIPanGestureRecognizer(target: self, action: #selector(resizeViewGestureRecognizer(_:)))
        resizeView.addGestureRecognizer(resizePanGesture)
        
        return resizeView
    }

    private func addDragGestureViewTo(view: UIView){
        let dragDetectView = UIView()
        dragDetectView.backgroundColor = .green.withAlphaComponent(0.2)
        let aspect = view.frame.width * 0.5
        let size = CGSize(width: aspect, height: aspect)
        dragDetectView.frame.size = size
        dragDetectView.center = view.center
        view.addSubview(dragDetectView)

        //Drag Pan Gesture
        let dragPanGesture = UIPanGestureRecognizer(target: self, action: #selector(dragViewGestureRecognizer(_:)))
        dragDetectView.addGestureRecognizer(dragPanGesture)
    }
}

// UIGesture Recognizables
extension CroppableView{

    @objc func resizeViewGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if let viewToDrag = gesture.view {
            //To resize on move
            moveToResizeView(view: viewToDrag, translation: translation)
            gesture.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
        }
        
        func moveToResizeView(view: UIView, translation: CGPoint){
            let newSize = CGSize(width: view.frame.size.width + translation.x,
                                 height: view.frame.size.width + translation.y)
            view.frame.size = newSize
            view.addCustomShapeBorderLayers()
            cropBounds = view.frame
            
            for sub in view.subviews{
                let size = newSize.width / 2
                sub.frame = CGRect(x: size / 2, y: size / 2, width: size, height: size)
            }
        }
    }
    
    @IBAction func dragViewGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        
        if let viewToDrag = sender.view {
            //To drag on move
            moveToDrag(view: viewToDrag, translation: translation)
            sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
        }
        
        func moveToDrag(view: UIView, translation: CGPoint){
            if let parent = view.superview{
                parent.center = CGPoint(x: parent.center.x + translation.x,
                                        y: parent.center.y + translation.y)
                
                cropBounds = parent.frame
            }
        }
    }
}
