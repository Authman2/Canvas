//
//  DrawingTool.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/9/18.
//

import Foundation

/** A Node on the canvas. A node is basically just any curve, line, or shape that appears on the canvas
 and is selectable. */
public class Node: NSObject, Codable {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The drawing path of the tool. */
    var path: CGMutablePath
    
    /** A copy of the bezier points. */
    var bezierPoints: [[CGPoint]]
    
    /** A copy of the bezier path types. */
    var bezierTypes: [CGPathElementType]
    
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
    
    /** Whether or not this node is selectable. */
    var allowsSelection: Bool
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NodeCodingKeys.self)
        path = CGMutablePath()
//        brush = try container.decode(Brush.self, forKey: NodeCodingKeys.nodeBrush)
        brush = Brush.Default
        firstPoint = try container.decode(CGPoint.self, forKey: NodeCodingKeys.nodeFirstPoint)
        lastPoint = try container.decode(CGPoint.self, forKey: NodeCodingKeys.nodeLastPoint)
        points = try container.decode([CGPoint].self, forKey: NodeCodingKeys.nodePoints)
        boundingBox = try container.decode(CGRect.self, forKey: NodeCodingKeys.nodeBoundingBox)
        id = try container.decode(Int.self, forKey: NodeCodingKeys.nodeID)
        bezierPoints = try container.decode([[CGPoint]].self, forKey: NodeCodingKeys.nodeBezPoints)
        bezierTypes = try container.decode([Int32].self, forKey: NodeCodingKeys.nodeBezTypes).map { CGPathElementType(rawValue: $0) ?? .moveToPoint }
        allowsSelection = try container.decode(Bool.self, forKey: NodeCodingKeys.nodeAllowsSelection)
    }
    
    override init() {
        path = CGMutablePath()
        bezierPoints = []
        bezierTypes = []
        brush = Brush.Default
        firstPoint = CGPoint()
        lastPoint = CGPoint()
        points = []
        boundingBox = CGRect()
        id = 0
        allowsSelection = true
        super.init()
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
        n.brush = brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        n.allowsSelection = allowsSelection
        n.bezierTypes = bezierTypes
        n.bezierPoints = bezierPoints
        return n
    }
    
    public override func mutableCopy() -> Any {
        let n = Node()
        n.path = path
        n.brush = brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        n.allowsSelection = allowsSelection
        n.bezierTypes = bezierTypes
        n.bezierPoints = bezierPoints
        return n
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let n = Node()
        n.path = path
        n.brush = brush
        n.firstPoint = firstPoint
        n.lastPoint = lastPoint
        n.id = id
        n.points = points
        n.boundingBox = boundingBox
        n.allowsSelection = allowsSelection
        n.bezierTypes = bezierTypes
        n.bezierPoints = bezierPoints
        return n
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NodeCodingKeys.self)
//        try container.encode(brush, forKey: NodeCodingKeys.nodeBrush)
        try container.encode(firstPoint, forKey: NodeCodingKeys.nodeFirstPoint)
        try container.encode(lastPoint, forKey: NodeCodingKeys.nodeLastPoint)
        try container.encode(id, forKey: NodeCodingKeys.nodeID)
        try container.encode(points, forKey: NodeCodingKeys.nodePoints)
        try container.encode(boundingBox, forKey: NodeCodingKeys.nodeBoundingBox)
        try container.encode(allowsSelection, forKey: NodeCodingKeys.nodeAllowsSelection)
        
        let bPoints = path.bezierPointsAndTypes.map { $0.0 }.count == 0 ? bezierPoints : path.bezierPointsAndTypes.map { $0.0 }
        let bTypes = path.bezierPointsAndTypes.map { $0.1.rawValue }.count == 0 ? bezierTypes.map { $0.rawValue } : path.bezierPointsAndTypes.map { $0.1.rawValue }
        try container.encode(bPoints, forKey: NodeCodingKeys.nodeBezPoints)
        try container.encode(bTypes, forKey: NodeCodingKeys.nodeBezTypes)
    }
}


/** The type of tool that is being used to draw. */
public enum CanvasTool: Int32 {
    case pen = 0
    case eraser = 1
    case line = 2
    case rectangle = 3
    case ellipse = 4
    case selection = 5
    case eyedropper = 6
    case paint = 7
}

