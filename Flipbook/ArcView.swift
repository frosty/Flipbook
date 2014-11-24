//
//  ArcView.swift
//  Flipbook
//
//  Created by James Frost on 24/11/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ArcView: UIView {
    
    var color: UIColor = UIColor.greenColor() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.shapeLayer.strokeColor = self.color.CGColor
            }
        }
    }
    
    var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    override var bounds: CGRect {
        didSet {
            updateLayerPath()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor(white: 0.278, alpha: 1.0)
        
        shapeLayer.strokeColor = color.CGColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapSquare
        shapeLayer.strokeEnd = 1.0
        shapeLayer.strokeStart = 0.0
        shapeLayer.fillColor = UIColor.clearColor().CGColor

        updateLayerPath()
        
        layer.addSublayer(shapeLayer)
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.repeatCount = 0
        animation.autoreverses = false
        animation.fromValue = 0.0
        animation.toValue = 1.0
        shapeLayer.addAnimation(animation, forKey: "animateStroke")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layer.needsDisplayOnBoundsChange = true
    }
    
    func stopAnimating() {
        layer.removeAnimationForKey("animateStroke")
    }
    
    func updateLayerPath() {
        let ics = intrinsicContentSize()

        let path = UIBezierPath(roundedRect: CGRect(x: shapeLayer.lineWidth / 2.0, y: shapeLayer.lineWidth / 2.0, width: ics.width - shapeLayer.lineWidth, height: ics.height - shapeLayer.lineWidth), cornerRadius: ics.width)
        
        shapeLayer.position = CGPoint(x: 0, y: 0)

        shapeLayer.path = path.CGPath
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
/*    CAShapeLayer *_shapeLayer;
    }
    
    - (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _angle = 0;
        
        self.backgroundColor = [UIColor colorWithWhite:0.278 alpha:1.000];
        _shapeLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*120, 2.0*120)
            cornerRadius:120];
        // Center the shape in self.view
        _shapeLayer.position = CGPointMake(CGRectGetMidX(self.frame)-120,
            CGRectGetMidY(self.frame)-120);
        
        _shapeLayer.path = path.CGPath;
        _shapeLayer.strokeColor = [UIColor greenColor].CGColor;
        _shapeLayer.lineWidth = 20;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeEnd = 0.0;
        _shapeLayer.strokeStart = 0.0;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.myColor = [UIColor greenColor];
        [self.layer addSublayer:_shapeLayer];
        
        CABasicAnimation *theAnimation;
        
        theAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        theAnimation.duration = 5.0;
        theAnimation.repeatCount = HUGE_VALF;
        theAnimation.autoreverses = NO;
        theAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        theAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [_shapeLayer addAnimation:theAnimation forKey:@"animateStroke"];
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.layer setNeedsDisplayOnBoundsChange:YES];
        
    }
    return self;
    }
    
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.myColor = [UIColor purpleColor];
    
    _shapeLayer.strokeColor = [self myColor].CGColor;
    }
    
    - (void)inParameter:(int)tag hasChanged:(float)value {
        // Parameter slider value has changed on the "Control Panel"
        if (tag == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _shapeLayer.lineWidth = value;
                });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect frame = _shapeLayer.frame;
                frame.origin.y = value;
                _shapeLayer.frame = frame;
                });
        }
        
        //    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
        }
        
        - (void)setColor:(UIColor *)color{
            self.myColor = color;
            dispatch_async(dispatch_get_main_queue(), ^{
                _shapeLayer.strokeColor = [self myColor].CGColor;
                });
        }
*/
