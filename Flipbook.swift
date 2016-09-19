//
//  Flipbook.swift
//  Flipbook
//
//  Created by James Frost on 21/11/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import Foundation
import UIKit

class Flipbook: NSObject {
    
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(Flipbook.displayLinkTick))
    
    // The view to capture
    private var targetView: UIView?
    private var duration: TimeInterval?
    private var startTime: CFTimeInterval?
    private var imagePrefix: String!
    private var imageCounter = 0
    
    // Render the target view to images for the specified duration
    func renderTargetView(view: UIView, duration: TimeInterval, imagePrefix: String, frameInterval: Int = 1) {
        assert(frameInterval >= 1)
        self.targetView = view
        self.duration = duration
        self.imagePrefix = imagePrefix
        
        imageCounter = 0
        displayLink.frameInterval = frameInterval
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        
        print("[Flipbook] Starting capture...")
    }
    
    func renderTargetView(view: UIView, imagePrefix: String, frameCount: Int, updateBlock: (_ view: UIView, _ frame: Int) -> Void) {
        self.imagePrefix = imagePrefix
        
        print("[Flipbook] Starting capture...")
        for frame in 0..<frameCount {
            updateBlock(view, frame)
            renderViewToImage(view: view)
        }
        print("[Flipbook] Images exported to: \(documentsDirectory()!)")
        print("[Flipbook] Capture complete!")
    }
    
    func displayLinkTick(sender: CADisplayLink) {
        if startTime == nil {
            startTime = sender.timestamp
        }
        
        renderViewToImage(view: self.targetView)
        
        if sender.timestamp - startTime! > duration! {
            sender.invalidate()
            sender.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
            
            print("[Flipbook] Images exported to: \(documentsDirectory()!)")
            print("[Flipbook] Capture complete!")
        }
    }
    
    private func newImagePath() -> String? {
        if let documentsDirectory = documentsDirectory() {
            
            let imagePath = (documentsDirectory as NSString).appendingPathComponent(String(format: "%@-%d@2x.png", imagePrefix, imageCounter))
            
            imageCounter += 1
            return imagePath
        }
        
        return nil
    }
    
    private func renderViewToImage(view: UIView?) {
        if let snapshot = view?.snapshotImage() {
            if let imagePath = self.newImagePath() {
                
                try! UIImagePNGRepresentation(snapshot)?.write(to: URL(fileURLWithPath: imagePath))
                
            }
        }
    }
    
    private func documentsDirectory() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.last
    }
}

extension UIView {
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 2.0)
        
        let layer: CALayer = self.layer.presentation() as CALayer? ?? self.layer
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}
