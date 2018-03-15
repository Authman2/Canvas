//
//  DrawingTool.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/9/18.
//

import Foundation

/** A Node on the canvas. A node is basically just any curve, line, or shape that appears on the canvas
 and is selectable. */
public class Node: UIBezierPath {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The drawing path of the tool. */
    var path: CGMutablePath
    
    /** The brush that the tool should use to draw. */
    var brush: Brush
    
    /** The first point of the node. */
    var firstPoint: CGPoint
    
    /** The last point of the node. */
    var lastPoint: CGPoint
    
    /** The id used to identify different nodes on the canvas. */
    var id: Int
    
    /** The points used for detecting touches inside of the node. */
    var points: [CGPoint]
    
    /** The bounding area of the entire shape. */
    var boundingBox: CGRect
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        path = aDecoder.decodeObject(forKey: "canvas_path") as! CGMutablePath
        brush = aDecoder.decodeObject(forKey: "canvas_brush") as! Brush
        firstPoint = aDecoder.decodeCGPoint(forKey: "canvas_firstPoint")
        lastPoint = aDecoder.decodeCGPoint(forKey: "canvas_lastPoint")
        points = aDecoder.decodeObject(forKey: "canvas_points") as! [CGPoint]
        boundingBox = aDecoder.decodeCGRect(forKey: "canvas_boundingBox")
        id = aDecoder.decodeInteger(forKey: "canvas_id")
        super.init(coder: aDecoder)
        lineCapStyle = .round
    }
    
    override init() {
        path = CGMutablePath()
        brush = Brush.Default
        firstPoint = CGPoint()
        lastPoint = CGPoint()
        points = []
        boundingBox = CGRect()
        id = 0
        super.init()
        lineCapStyle = .round
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    func setInitialPoint(point: CGPoint) {}
    
    func move(from: CGPoint, to: CGPoint) {}
    
    func addPathLastLastPoint(p1: CGPoint, p2: CGPoint, currentPoint: CGPoint) -> CGRect { return CGRect() }
    
    func draw() {}

    func addPoint(point: CGPoint) { points.append(point) }
    
    func setBoundingBox() {
        boundingBox = CGRect(x: self.firstPoint.x, y: self.firstPoint.y, width: self.lastPoint.x - self.firstPoint.x, height: self.lastPoint.y - self.firstPoint.y)
    }
    
    func contains(point: CGPoint) -> Bool { return false }
    
    func moveNode(touch: UITouch, canvas: Canvas) {}
    
    
    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
    public override func copy() -> Any {
        let n = Node()
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
        let n = Node()
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
        let n = Node()
        n.path = path
        n.brush = brush.copy() as! Brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        return n
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(path, forKey: "canvas_path")
        aCoder.encode(brush, forKey: "canvas_brush")
        aCoder.encode(firstPoint, forKey: "canvas_firstPoint")
        aCoder.encode(lastPoint, forKey: "canvas_lastPoint")
        aCoder.encode(id, forKey: "canvas_id")
        aCoder.encode(points, forKey: "canvas_points")
        aCoder.encode(boundingBox, forKey: "canvas_boundingBox")
    }
    
    
}


/** The type of tool that is being used to draw. */
public enum CanvasTool {
    case pen
    case eraser
    case line
    case rectangle
    case rectangleFill
    case ellipse
    case ellipseFill
    case selection
}

