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
        return (points.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= 5 && abs(point.y - p.y) <= 5 })) || (path.bezierPoints.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= 5 && abs(point.y - p.y) <= 5 }))
    }
    
    func moveNode(to: CGPoint, canvas: Canvas) {
        var instructions = path.bezierPointsAndTypes
        path = CGMutablePath()
        
        for i in 0..<instructions.count {
            switch(instructions[i].1) {
            case .moveToPoint:
                let dx = CGFloat(5)
                let dy = CGFloat(5)
                instructions[i].0[0].x += dx
                instructions[i].0[0].y += dy
                break
            case .addQuadCurveToPoint:
                let dx = CGFloat(5)
                let dy = CGFloat(5)
                instructions[i].0[0].x += dx
                instructions[i].0[0].y += dy
                let dx2 = CGFloat(5)
                let dy2 = CGFloat(5)
                instructions[i].0[1].x += dx2
                instructions[i].0[1].y += dy2
                break
            case .addLineToPoint:
                let dx = CGFloat(5)
                let dy = CGFloat(5)
                instructions[i].0[0].x += dx
                instructions[i].0[0].y += dy
                break
            case .addCurveToPoint:
                let dx = CGFloat(5)
                let dy = CGFloat(5)
                instructions[i].0[0].x += dx
                instructions[i].0[0].y += dy
                let dx2 = CGFloat(5)
                let dy2 = CGFloat(5)
                instructions[i].0[1].x += dx2
                instructions[i].0[1].y += dy2
                let dx3 = CGFloat(5)
                let dy3 = CGFloat(5)
                instructions[i].0[2].x += dx3
                instructions[i].0[2].y += dy3
                break
            case .closeSubpath:
                continue
            }
        }
        
        for i in 0..<instructions.count {
            switch(instructions[i].1) {
            case .moveToPoint:
                path.move(to: instructions[i].0[0])
                break
            case .addQuadCurveToPoint:
                path.addQuadCurve(to: instructions[i].0[0], control: instructions[i].0[1])
                break
            case .addLineToPoint:
                path.addLine(to: instructions[i].0[0])
                break
            case .addCurveToPoint:
                path.addCurve(to: instructions[i].0[0], control1: instructions[i].0[1], control2: instructions[i].0[2])
                break
            case .closeSubpath:
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
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}

