//
//  CurveBinder.swift
//  Binder
//
//  Created by Mahesh.me on 1/30/17.
//  Copyright © 2017 Mahesh.me. All rights reserved.
//

import UIKit

class CurveBinder: UIView {

    var curveLayer: CAShapeLayer!
    var curvePath: UIBezierPath!
    var boundedButton: UIButton!
    
    var finalCoefficients: CoefficientObj!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray
        
        curvePath = UIBezierPath.init()
        curvePath.lineWidth = 2
        
        curveLayer = CAShapeLayer.init()
        curveLayer.lineWidth = 2
        curveLayer.strokeColor = UIColor.black.cgColor
        curveLayer.fillColor = UIColor.clear.cgColor
        
        boundedButton = UIButton.init()
        boundedButton.backgroundColor = UIColor.red
        self.addSubview(boundedButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        curveLayer.frame = self.bounds
        
        boundedButton.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        boundedButton.layer.cornerRadius = boundedButton.frame.size.width/2
        
        self.bringSubview(toFront: boundedButton)
    }
    
    override func draw(_ rect: CGRect) {
        //        caluculateCoefficients(firstPoint: CGPoint.init(x: 0, y: -10), secondPoint: CGPoint.init(x: 5, y: 0), thirdPoint: CGPoint.init(x: 10, y: -10))
        caluculateCoefficients(firstPoint: CGPoint.init(x: 0, y: self.frame.size.height - 0), secondPoint: CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height - self.frame.size.height/2), thirdPoint: CGPoint.init(x: self.frame.size.width, y: self.frame.size.height - 0))
        
        curvePath.removeAllPoints()
        curvePath.move(to: CGPoint.init(x: 0, y: 0))
        curvePath.addQuadCurve(to: CGPoint.init(x: self.frame.size.width, y: 0), controlPoint: CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height))
        
        curveLayer.path = curvePath.cgPath
        self.layer.addSublayer(curveLayer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint: CGPoint = (touches.first?.location(in: self))!
        
        let y = (finalCoefficients.aFinal*(Float(pow(currentPoint.x, 2)))) + (finalCoefficients.bFinal * Float(currentPoint.x)) + finalCoefficients.cFinal
        
        boundedButton.center = CGPoint.init(x: currentPoint.x, y: (self.frame.size.height - CGFloat(y)))
    }
    
    func caluculateCoefficients(firstPoint: CGPoint, secondPoint: CGPoint, thirdPoint: CGPoint){
        
        let firstTempCoeffi =  CoefficientObj.init(point: firstPoint)
        let secondTempCoeffi = CoefficientObj.init(point: secondPoint)
        let thirdTempCoeffi = CoefficientObj.init(point: thirdPoint)
        
        //Matrix determination caluculation
        let det = (firstTempCoeffi.aInitial*(secondTempCoeffi.bInitial * thirdTempCoeffi.cInitial - thirdTempCoeffi.bInitial*secondTempCoeffi.cInitial)) - (firstTempCoeffi.bInitial*(secondTempCoeffi.aInitial * thirdTempCoeffi.cInitial - thirdTempCoeffi.aInitial * secondTempCoeffi.cInitial)) + (firstTempCoeffi.cInitial*(secondTempCoeffi.aInitial * thirdTempCoeffi.bInitial - thirdTempCoeffi.aInitial * secondTempCoeffi.bInitial))
        
        //Inverce value caluculation first row
        firstTempCoeffi.aFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [secondTempCoeffi.bInitial, secondTempCoeffi.cInitial], secondRow: [thirdTempCoeffi.bInitial, thirdTempCoeffi.cInitial])
        
        firstTempCoeffi.bFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [firstTempCoeffi.cInitial, firstTempCoeffi.bInitial], secondRow: [thirdTempCoeffi.cInitial, thirdTempCoeffi.bInitial])
        
        firstTempCoeffi.cFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [firstTempCoeffi.bInitial, firstTempCoeffi.cInitial], secondRow: [secondTempCoeffi.bInitial, secondTempCoeffi.cInitial])
        
        //Inverce value caluculation second row
        secondTempCoeffi.aFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [secondTempCoeffi.cInitial, secondTempCoeffi.aInitial], secondRow: [thirdTempCoeffi.cInitial, thirdTempCoeffi.aInitial])
        
        secondTempCoeffi.bFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [firstTempCoeffi.aInitial, firstTempCoeffi.cInitial], secondRow: [thirdTempCoeffi.aInitial, thirdTempCoeffi.cInitial])
        
        secondTempCoeffi.cFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [firstTempCoeffi.cInitial, firstTempCoeffi.aInitial], secondRow: [secondTempCoeffi.cInitial, secondTempCoeffi.aInitial])
        
        //Inverce value caluculation third row
        thirdTempCoeffi.aFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [secondTempCoeffi.aInitial, secondTempCoeffi.bInitial], secondRow: [thirdTempCoeffi.aInitial, thirdTempCoeffi.bInitial])
        
        thirdTempCoeffi.bFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [firstTempCoeffi.bInitial, firstTempCoeffi.aInitial], secondRow: [thirdTempCoeffi.bInitial, thirdTempCoeffi.aInitial])
        
        thirdTempCoeffi.cFinal = (1/det) * determinationOfTwoByTwoMatrix(firstRow: [firstTempCoeffi.aInitial, firstTempCoeffi.bInitial], secondRow: [secondTempCoeffi.aInitial, secondTempCoeffi.bInitial])
        
        //Final coefficient calluculation
        finalCoefficients = CoefficientObj.init(point: CGPoint.zero)
        
        finalCoefficients.aFinal = (firstTempCoeffi.aFinal * Float(firstPoint.y)) + (firstTempCoeffi.bFinal * Float(secondPoint.y)) + (firstTempCoeffi.cFinal * Float(thirdPoint.y))
        
        finalCoefficients.bFinal = (secondTempCoeffi.aFinal * Float(firstPoint.y)) + (secondTempCoeffi.bFinal * Float(secondPoint.y)) + (secondTempCoeffi.cFinal * Float(thirdPoint.y))
        
        finalCoefficients.cFinal = (thirdTempCoeffi.aFinal * Float(firstPoint.y)) + (thirdTempCoeffi.bFinal * Float(secondPoint.y)) + (thirdTempCoeffi.cFinal * Float(thirdPoint.y))
        
        print("\(finalCoefficients.aFinal!) X^2 + \(finalCoefficients.bFinal!) X + \(finalCoefficients.cFinal!)")
    }
    
    func determinationOfTwoByTwoMatrix(firstRow: Array<Float>, secondRow: Array<Float>) -> Float{
        
        let det: Float = ((firstRow[0] * secondRow[1]) - (secondRow[0] * firstRow[1]))
        return det
    }
}

class CoefficientObj: NSObject {
    
    var aInitial, bInitial, cInitial: Float!
    var aFinal, bFinal, cFinal : Float!
    
    init(point: CGPoint){
        super.init()
        
        aInitial = Float(pow(point.x, 2))
        bInitial = Float(point.x)
        cInitial = 1
    }
}

