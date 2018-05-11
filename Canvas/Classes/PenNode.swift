//
//  PenTool.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/9/18.
//

import Foundation

/** A standard pen tool for drawing on the canvas. */
public class PenNode: Node {
    
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
    
    public override init() {
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let a = self.bezierPoints
        let b = self.bezierTypes
        path = CGMutablePath()
        
        for i in 0..<b.count {
            switch(b[i]) {
            case .moveToPoint:
                path.move(to: CGPoint(x: a[i][0].x, y: a[i][0].y))
                break
            case .addLineToPoint:
                path.addLine(to: CGPoint(x: a[i][0].x, y: a[i][0].y))
                break
            case .addQuadCurveToPoint:
                path.addQuadCurve(to: CGPoint(x: a[i][0].x, y: a[i][0].y), control: CGPoint(x: a[i][1].x, y: a[i][1].y))
                break
            case .addCurveToPoint:
                path.addCurve(to: CGPoint(x: a[i][0].x, y: a[i][0].y), control1: CGPoint(x: a[i][1].x, y: a[i][1].y), control2: CGPoint(x: a[i][2].x, y: a[i][2].y))
                break
            default:
                path.closeSubpath()
                break
            }
        }
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    override func setInitialPoint(point: CGPoint) {
        self.firstPoint = point
        path.move(to: point)
    }
    
    override func move(from: CGPoint, to: CGPoint) {
        self.lastPoint = to
        path.addQuadCurve(to: midpoint(a: from, b: to), control: from)
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
        var instructions = bezierTypes
        var points = bezierPoints
        path = CGMutablePath()
        
        for i in 0..<instructions.count {
            switch(instructions[i]) {
            case .moveToPoint:
                points[i][0].x += touch.deltaX
                points[i][0].y += touch.deltaY
                path.move(to: CGPoint(x: points[i][0].x, y: points[i][0].y))
                break
            case .addLineToPoint:
                points[i][0].x += touch.deltaX
                points[i][0].y += touch.deltaY
                path.addLine(to: CGPoint(x: points[i][0].x, y: points[i][0].y))
                break
            case .addQuadCurveToPoint:
                points[i][0].x += touch.deltaX
                points[i][0].y += touch.deltaY
                points[i][1].x += touch.deltaX
                points[i][1].y += touch.deltaY
                path.addQuadCurve(to: CGPoint(x: points[i][0].x, y: points[i][0].y), control: CGPoint(x: points[i][1].x, y: points[i][1].y))
                break
            case .addCurveToPoint:
                points[i][0].x += touch.deltaX
                points[i][0].y += touch.deltaY
                points[i][1].x += touch.deltaX
                points[i][1].y += touch.deltaY
                points[i][2].x += touch.deltaX
                points[i][2].y += touch.deltaY
                path.addCurve(to: CGPoint(x: points[i][0].x, y: points[i][0].y), control1: CGPoint(x: points[i][1].x, y: points[i][1].y), control2: CGPoint(x: points[i][2].x, y: points[i][2].y))
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
        
        bezierPoints = path.bezierPointsAndTypes.map { $0.0 }
        bezierTypes = path.bezierPointsAndTypes.map { $0.1 }
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

