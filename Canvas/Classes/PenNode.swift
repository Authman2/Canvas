//
//  PenTool.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/9/18.
//

import Foundation

/** A standard pen tool for drawing on the canvas. */
class PenNode: Node {
    
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
        move(to: point)
    }
    
    override func move(from: CGPoint, to: CGPoint) {
        self.lastPoint = to
        addQuadCurve(to: midpoint(a: from, b: to), controlPoint: from)
    }
    
    override func addPathLastLastPoint(p1: CGPoint, p2: CGPoint, currentPoint: CGPoint) -> CGRect {
        let mid1 = midpoint(a: p1, b: p2)
        let mid2 = midpoint(a: currentPoint, b: p2)
        
        let subpath = CGMutablePath()
        subpath.move(to: mid1)
        subpath.addQuadCurve(to: mid2, control: p2)
        let bounds = subpath.boundingBox
        
        path.addPath(subpath)
        subpath.closeSubpath()
        return bounds
    }
    
    override func contains(point: CGPoint) -> Bool {
        return (points.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= brush.thickness && abs(point.y - p.y) <= brush.thickness })) || (path.bezierPoints.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= brush.thickness && abs(point.y - p.y) <= brush.thickness }))
    }
    
    override func moveNode(touch: UITouch, canvas: Canvas) {
        var instructions = path.bezierPointsAndTypes
        path = CGMutablePath()
        
        for i in 0..<instructions.count {
            switch(instructions[i].1) {
            case .moveToPoint:
                path.move(to: CGPoint(x: instructions[i].0[0].x + touch.deltaX, y: instructions[i].0[0].y + touch.deltaY))
                break
            case .addLineToPoint:
                path.addLine(to: CGPoint(x: instructions[i].0[0].x + touch.deltaX, y: instructions[i].0[0].y + touch.deltaY))
                break
            case .addQuadCurveToPoint:
                path.addQuadCurve(to: CGPoint(x: instructions[i].0[0].x + touch.deltaX, y: instructions[i].0[0].y + touch.deltaY), control: CGPoint(x: instructions[i].0[1].x + touch.deltaX, y: instructions[i].0[1].y + touch.deltaY))
                break
            case .addCurveToPoint:
                path.addCurve(to: CGPoint(x: instructions[i].0[0].x + touch.deltaX, y: instructions[i].0[0].y + touch.deltaY), control1: CGPoint(x: instructions[i].0[1].x + touch.deltaX, y: instructions[i].0[1].y + touch.deltaY), control2: CGPoint(x: instructions[i].0[2].x + touch.deltaX, y: instructions[i].0[2].y + touch.deltaY))
                break
            default:
                path.closeSubpath()
                break
            }
        }
    }
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.addPath(path)
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setStrokeColor(brush.color.cgColor)
        context.setBlendMode(.normal)
        context.setMiterLimit(brush.miter)
        context.setFlatness(brush.flatness)
        context.setAlpha(brush.opacity)
        context.strokePath()
    }
    
    
    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
    public override func copy() -> Any {
        let n = PenNode()
        n.path = path
        n.brush = brush.copy() as! Brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        return n
    }
    
    public override func mutableCopy() -> Any {
        let n = PenNode()
        n.path = path
        n.brush = brush.copy() as! Brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        return n
    }
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let n = PenNode()
        n.path = path
        n.brush = brush.copy() as! Brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        return n
    }
    
    
}

