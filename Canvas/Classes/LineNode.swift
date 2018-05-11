//
//  LineNode.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/13/18.
//

import Foundation

/** A straight line node. */
public class LineNode: Node {
    
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
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    public init(first: CGPoint, last: CGPoint) {
        super.init()
        firstPoint = first
        lastPoint = last
    }
    
    override init() {
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
        points = pointsOnLine(startPoint: firstPoint, endPoint: lastPoint)
        return points.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= brush.thickness && abs(point.y - p.y) <= brush.thickness }) || (path.bezierPoints.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= brush.thickness && abs(point.y - p.y) <= brush.thickness }))
    }
    
    override func moveNode(touch: UITouch, canvas: Canvas) {        
        firstPoint.x += touch.deltaX
        firstPoint.y += touch.deltaY
        
        lastPoint.x += touch.deltaX
        lastPoint.y += touch.deltaY
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
     *         OTHER        *
     *                      *
     ************************/
    
    /** Returns an array of points that lie on this line. */
    func pointsOnLine(startPoint : CGPoint, endPoint : CGPoint) -> [CGPoint] {
        var allPoints: [CGPoint] = [CGPoint]()
        
        let deltaX = fabs(endPoint.x - startPoint.x)
        let deltaY = fabs(endPoint.y - startPoint.y)
        
        var x = startPoint.x
        var y = startPoint.y
        var err = deltaX - deltaY
        
        var sx = -0.5
        var sy = -0.5
        if(startPoint.x < endPoint.x){ sx = 0.5 }
        if(startPoint.y < endPoint.y){ sy = 0.5; }
        
        repeat {
            let pointObj = CGPoint(x: x, y: y)
            allPoints.append(pointObj)
            
            let e = 2*err
            if(e > -deltaY) {
                err -= deltaY
                x += CGFloat(sx)
            }
            if(e < deltaX) {
                err += deltaX
                y += CGFloat(sy)
            }
        } while (round(x) != round(endPoint.x) && round(y) != round(endPoint.y));
        
        allPoints.append(endPoint)
        return allPoints
    }

    
    public override func copy() -> Any {
        let n = LineNode()
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
        let n = LineNode()
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
        let n = LineNode()
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
