//
//  Bind.swift
//  Binder
//
//  Created by Mahesh.me on 1/19/17.
//  Copyright © 2017 Mahesh.me. All rights reserved.
//

import UIKit
import Foundation

class Bind: UIView {
    
    var circlePath: UIBezierPath!
    var circleLayer: CAShapeLayer!
    var boundedButton: UIButton!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        circlePath = UIBezierPath.init()
        circlePath.lineWidth = 2
        
        circleLayer = CAShapeLayer.init()
        circleLayer.lineWidth = 2
        circleLayer.strokeColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        
        boundedButton = UIButton.init()
        boundedButton.backgroundColor = UIColor.red
        self.addSubview(boundedButton)
       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = self.bounds
        
        boundedButton.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        boundedButton.layer.cornerRadius = boundedButton.frame.size.width/2
        
        self.bringSubview(toFront: boundedButton)
    }
    
    override func draw(_ rect: CGRect) {
        
        circlePath.addArc(withCenter: CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: self.frame.size.width/2, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        circleLayer.path = circlePath.cgPath
        self.layer.addSublayer(circleLayer)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint: CGPoint = (touches.first?.location(in: self))!
        reCenter(touchPoint: currentPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint: CGPoint = (touches.first?.location(in: self))!
        reCenter(touchPoint: currentPoint)
        }
    
    func reCenter(touchPoint: CGPoint) {
        
        let center = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
        var angle  = (Double(atan(fabs(center.y - touchPoint.y)/fabs(center.x - touchPoint.x)))*180)/M_PI
        if touchPoint.x > self.frame.size.width/2 {
            if touchPoint.y < self.frame.size.height/2 {
                angle = 270 + (90 - angle)
            }
        }
        else{
            if touchPoint.y > self.frame.size.height/2 {
                angle = 90 + (90 - angle)
            }
            else{
                angle += 180
            }
        }
        let rad = (angle*M_PI)/180
        let x = Double(self.frame.size.width/2) * cos(rad) + Double(self.frame.size.width/2)
        let y = Double(self.frame.size.width/2) * sin(rad) + Double(self.frame.size.height/2)
        boundedButton.center = CGPoint.init(x: x, y: y)
    }
}
