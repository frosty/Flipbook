//
//  ViewController.swift
//  Flipbook
//
//  Created by James Frost on 21/11/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var activityFlipbook: Flipbook!
    var arcFlipbook: Flipbook!
    
    @IBOutlet weak var arcView: ArcView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.backgroundColor = UIColor.white
        view.addSubview(activity)
        activity.center = view.center
        
        let arcView = ArcView(frame: CGRect(x: 20, y: 20, width: 120, height: 120))
        view.addSubview(arcView)
        arcFlipbook = Flipbook()
        arcView.shapeLayer.strokeEnd = 0
        

        arcFlipbook.renderTargetView(view: arcView, imagePrefix: "arc", frameCount: 60, updateBlock: {
            (view, frame) in
            if let arcView = view as? ArcView {
                arcView.shapeLayer.strokeEnd = CGFloat(frame) * (1.0 / 60.0)
            }
        })
        

        activityFlipbook = Flipbook()
        activityFlipbook.renderTargetView(view: activity, duration: 3.0, imagePrefix: "activity")
        activity.startAnimating()
    }
    
}

