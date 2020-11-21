//
//  DrawView.swift
//  MahotoSasaki-Lab3
//
//  Created by Mahoto Sasaki on 9/13/20.
//  Copyright © 2020 mo3aru. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentDrawing:Drawing? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var drawings: [Drawing] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func drawStroke(drawing:Drawing){
        drawing.color.setStroke()
        let path = createQuadPath(points: drawing.points)
        path.lineWidth = drawing.thickness
        path.stroke(with: CGBlendMode.copy, alpha: drawing.opacity)
        //path.stroke()
    }
    
    private func midpoint(first: CGPoint, second: CGPoint) -> CGPoint { // implement this function here
        return CGPoint(x: abs((first.x+second.x) / 2), y: abs((first.y+second.y) / 2))
    }
    
    private func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath() //Create the path object
        path.lineCapStyle = .round
        path.lineJoinStyle = .round

        if(points.count < 2){ //There are no points to add to this path
            path.move(to: points[0])
            path.addLine(to: points[0])
            return path
        }
        path.move(to: points[0]) //Start the path on the first point

        for i in 1..<points.count - 1{
            let firstMidpoint = midpoint(first: path.currentPoint, second: points[i]) //Get midpoint between the path's last point and the next one in the array
            let secondMidpoint = midpoint(first: points[i], second: points[i+1]) //Get midpoint between the next point in the array and the one after it
            path.addCurve(to: secondMidpoint, controlPoint1: firstMidpoint, controlPoint2: points[i]) //This creates a cubic Bezier curve using math!
        }
 
        return path
    }

       
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        for drawing in drawings {
            drawStroke(drawing: drawing)
        }
        
        if let currentDrawing = currentDrawing {
            drawStroke(drawing: currentDrawing)
        }
    }
    

}
