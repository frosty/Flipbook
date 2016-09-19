//
//  InterfaceController.swift
//  Flipbook WatchKit Extension
//
//  Created by James Frost on 24/11/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var arcImage: WKInterfaceImage!
    @IBOutlet weak var activityImage: WKInterfaceImage!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        
        arcImage.setImageNamed("arc-")
        arcImage.startAnimatingWithImages(in: NSMakeRange(0, 60), duration: 1.0, repeatCount: 0)
        
        activityImage.setImageNamed("activity-")
        activityImage.startAnimatingWithImages(in: NSMakeRange(0, 62), duration: 1.0, repeatCount: 0)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }

}
