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
    
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: "displayLinkTick:")
    
    // The view to capture
    private var targetView: UIView?
    private var duration: NSTimeInterval?
    private var startTime: CFTimeInterval?
    private var imagePrefix: String!
    private var imageCounter = 0
    private var frameInSuperview = false

    // Render the target view to images for the specified duration
    func renderTargetView(view: UIView, duration: NSTimeInterval, imagePrefix: String, frameInterval: Int = 1, frameInSuperview: Bool = false) {
        assert(frameInterval >= 1)
        self.targetView = view
        self.duration = duration
        self.imagePrefix = imagePrefix
        self.frameInSuperview = frameInSuperview
        
        imageCounter = 0
        displayLink.frameInterval = frameInterval
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        println("[Flipbook] Starting capture...")
    }
    
    func renderTargetView(view: UIView, imagePrefix: String, frameCount: Int, updateBlock: (view: UIView, frame: Int) -> Void) {
        self.imagePrefix = imagePrefix
        
        for frame in 0..<frameCount {
            updateBlock(view: view, frame: frame)
            renderViewToImage(view, afterScreenUpdates: true)
        }
    }
    
    func displayLinkTick(sender: CADisplayLink) {
        if startTime == nil {
            startTime = sender.timestamp
        }
        
        renderViewToImage(self.targetView, afterScreenUpdates: false)
        
        if sender.timestamp - startTime! > duration {
            sender.invalidate()
            sender.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            
            println("[Flipbook] Images exported to: \(documentsDirectory()!)")
            println("[Flipbook] Capture complete!")
        }
    }
    
    private func newImagePath() -> String? {
        if let documentsDirectory = documentsDirectory() {
            let imagePath = documentsDirectory.stringByAppendingPathComponent(NSString(format: "%@-%d@2x.png", imagePrefix, imageCounter++))
            return imagePath
        }
        
        return nil
    }
    
    private func renderViewToImage(view: UIView?, afterScreenUpdates: Bool) {
        if let snapshot = view?.snapshotView(frameInSuperview, afterScreenUpdates: afterScreenUpdates) {
            if let imagePath = self.newImagePath() {
                UIImagePNGRepresentation(snapshot).writeToFile(imagePath, atomically: true)
            }
        }
    }
    
    private func documentsDirectory() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths.last as? String
    }
}

extension UIView {

    func snapshotView(frameInSuperview: Bool, afterScreenUpdates: Bool) -> UIImage {
        return frameInSuperview ? snapshotFrameOfViewInSuperview(afterScreenUpdates) : snapshotImage(afterScreenUpdates);
    }

    func snapshotImage(afterScreenUpdate: Bool) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 2.0)

        self.drawViewHierarchyInRect(CGRect(origin: CGPointZero, size:bounds.size), afterScreenUpdates: afterScreenUpdate)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }

    func snapshotFrameOfViewInSuperview(afterScreenUpdate: Bool) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(superview!.bounds.size, opaque, 2.0)

        superview?.drawViewHierarchyInRect(superview!.bounds, afterScreenUpdates: afterScreenUpdate)

        let superviewImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()

        let cropRect = CGRectApplyAffineTransform(frame, CGAffineTransformMakeScale(2.0, 2.0))
        let image: CGImageRef = CGImageCreateWithImageInRect(superviewImage.CGImage, cropRect)

        UIGraphicsEndImageContext()
        
        return UIImage(CGImage: image)!
    }
}
