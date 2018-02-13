//
//  LineNode.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/13/18.
//

import Foundation

/** A straight line node. */
class LineNode: Node {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    override func setInitialPoint(point: CGPoint) {
        self.firstPoint = point
    }
    
    override func move(from: CGPoint, to: CGPoint) {
        self.lastPoint = to
    }
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setStrokeColor(brush.color.cgColor)
        context.setMiterLimit(brush.miter)
        context.setFlatness(brush.flatness)
        context.setAlpha(brush.opacity)
        
        context.move(to: self.firstPoint)
        context.addLine(to: self.lastPoint)
        
        context.strokePath()
    }
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
