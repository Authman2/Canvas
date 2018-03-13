//
//  EllipseNode.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/13/18.
//

import Foundation

/** A node that is used to draw ellipses on the screen. */
class EllipseNode: Node {
    
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
        let center = CGPoint(x: boundingBox.minX + boundingBox.width / 2, y: boundingBox.minY + boundingBox.height / 2)
        let radius = boundingBox.width / 2
        let dx = point.x - center.x
        let dy = point.y - center.y
        let dist = sqrt((dx ** 2) + (dy ** 2))
        
        return dist <= radius
    }
    
    override func moveNode(touch: UITouch, canvas: Canvas) {
        boundingBox = boundingBox.offsetBy(dx: touch.deltaX, dy: touch.deltaY)
    }
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setMiterLimit(brush.miter)
        context.setFlatness(brush.flatness)
        context.setAlpha(brush.opacity)
        
        // Create a ellipse to draw.
        if self.shouldFill {
            context.setFillColor(brush.color.cgColor)
            context.fillEllipse(in: boundingBox)
        } else {
            context.setStrokeColor(brush.color.cgColor)
            context.strokeEllipse(in: boundingBox)
        }
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
