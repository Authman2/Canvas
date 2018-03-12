//
//  RectangleNode.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/13/18.
//

import Foundation

/** A node that is used to draw rectangles on the screen. */
class RectangleNode: Node {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    internal var shouldFill: Bool
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    required init?(coder aDecoder: NSCoder) {
        self.shouldFill = false
        super.init(coder: aDecoder)
    }
    
    init(shouldFill: Bool) {
        self.shouldFill = shouldFill
        super.init()
    }
    
    
    
    
    
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
    
    override func contains(point: CGPoint) -> Bool {
        return boundingBox.contains(point)
    }
    
    override func moveNode(to: CGPoint) {
        let rect = CGRect(x: self.firstPoint.x - (self.firstPoint.x - to.x), y: self.firstPoint.y - (self.firstPoint.y - to.y), width: self.lastPoint.x - self.firstPoint.x, height: self.lastPoint.y - self.firstPoint.y)
        boundingBox = rect
    }
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setMiterLimit(brush.miter)
        context.setFlatness(brush.flatness)
        context.setAlpha(brush.opacity)
        
        // Create a rectangle to draw.
        if self.shouldFill {
            context.setFillColor(brush.color.cgColor)
            context.fill(boundingBox)
        } else {
            context.setStrokeColor(brush.color.cgColor)
            context.stroke(boundingBox)
        }
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
