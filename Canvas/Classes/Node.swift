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
        path = CGMutablePath()
        brush = aDecoder.decodeObject(forKey: "canvas_brush_node") as! Brush
        firstPoint = aDecoder.decodeCGPoint(forKey: "canvas_firstPoint_node")
        lastPoint = aDecoder.decodeCGPoint(forKey: "canvas_lastPoint_node")
        points = aDecoder.decodeObject(forKey: "canvas_points_node") as! [CGPoint]
        boundingBox = aDecoder.decodeCGRect(forKey: "canvas_boundingBox_node")
        id = aDecoder.decodeInteger(forKey: "canvas_id_node")
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
        aCoder.encode(brush, forKey: "canvas_brush_node")
        aCoder.encode(firstPoint, forKey: "canvas_firstPoint_node")
        aCoder.encode(lastPoint, forKey: "canvas_lastPoint_node")
        aCoder.encode(id, forKey: "canvas_id_node")
        aCoder.encode(points, forKey: "canvas_points_node")
        aCoder.encode(boundingBox, forKey: "canvas_boundingBox_node")
    }
    
    
}


/** The type of tool that is being used to draw. */
public enum CanvasTool: Int32 {
    case pen = 0
    case eraser = 1
    case line = 2
    case rectangle = 3
    case rectangleFill = 4
    case ellipse = 5
    case ellipseFill = 6
    case selection = 7
}

