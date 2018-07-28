//
//  Node.swift
//  Canvas
//
//  Created by Adeola Uthman on 5/17/18.
//

import Foundation

/** A Node on the canvas. A node is basically just any curve, line, or shape that appears on the canvas and is selectable. */
public struct Node: Codable {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The type of node that this is. */
    public var nodeType: Int
    
    /** The mutable path to draw. */
    public var mutablePath: CGMutablePath
    
    /** The first point of the node. */
    public var firstPoint: CGPoint
    
    /** The last point of the node. */
    public var lastPoint: CGPoint
    
    /** The bounding area of the entire shape. */
    public var boundingBox: CGRect
    
    /** The shape layer that this node draws on. */
    public var shapeLayer: CAShapeLayer
    
    /** Whether or not this node is movable. */
    public var isMovable: Bool
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NodeCodingKeys.self)
        firstPoint = try container.decodeIfPresent(CGPoint.self, forKey: NodeCodingKeys.nodeFirstPoint) ?? CGPoint()
        lastPoint = try container.decodeIfPresent(CGPoint.self, forKey: NodeCodingKeys.nodeLastPoint) ?? CGPoint()
        boundingBox = try container.decodeIfPresent(CGRect.self, forKey: NodeCodingKeys.nodeBoundingBox) ?? CGRect()
        isMovable = try container.decodeIfPresent(Bool.self, forKey: NodeCodingKeys.nodeMovable) ?? true
        nodeType = try container.decodeIfPresent(Int.self, forKey: NodeCodingKeys.nodeType) ?? 0
        
        let fill = try container.decodeIfPresent([CGFloat].self, forKey: NodeCodingKeys.nodeFill) ?? [0,0,0,0]
        let stroke = try container.decodeIfPresent([CGFloat].self, forKey: NodeCodingKeys.nodeStroke) ?? [0,0,0,0]
        let cap = try container.decodeIfPresent(String.self, forKey: NodeCodingKeys.nodeLineCap) ?? kCALineCapRound
        let join = try container.decodeIfPresent(String.self, forKey: NodeCodingKeys.nodeLineJoin) ?? kCALineJoinRound
        let width = try container.decodeIfPresent(CGFloat.self, forKey: NodeCodingKeys.nodeLineWidth) ?? 5
        let miter = try container.decodeIfPresent(CGFloat.self, forKey: NodeCodingKeys.nodeMiter) ?? 1
        let bounds = try container.decodeIfPresent(CGRect.self, forKey: NodeCodingKeys.nodeBounds) ?? CGRect()
        let pos = try container.decodeIfPresent(CGPoint.self, forKey: NodeCodingKeys.nodePosition) ?? CGPoint()
        let bPoints = try container.decodeIfPresent([[CGPoint]].self, forKey: NodeCodingKeys.nodeBezPoints) ?? []
        let bTypes = (try container.decodeIfPresent([Int32].self, forKey: NodeCodingKeys.nodeBezTypes) ?? []).map {
            return CGPathElementType(rawValue: $0) ?? .moveToPoint
        }
        
        shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = cap
        shapeLayer.lineJoin = join
        shapeLayer.lineWidth = width
        shapeLayer.miterLimit = miter
        shapeLayer.bounds = bounds
        shapeLayer.position = pos
        let fillIsBW = fill == [0, 1, 1, 1] ? true : false
        let strokeIsBW = stroke == [0, 1, 1, 1] ? true : false
        if fillIsBW {
            shapeLayer.fillColor = fill == [-1,-1,-1,-1] ? nil : CGColor(colorSpace: CGColorSpaceCreateDeviceGray(), components: fill)
        } else {
            shapeLayer.fillColor = fill == [-1,-1,-1,-1] ? nil : CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: fill)
        }
        if strokeIsBW {
            shapeLayer.strokeColor = stroke == [-1,-1,-1,-1] ? nil : CGColor(colorSpace: CGColorSpaceCreateDeviceGray(), components: stroke)
        } else {
            shapeLayer.strokeColor = stroke == [-1,-1,-1,-1] ? nil : CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: stroke)
        }
        
        // Re-build the cgpath.
        mutablePath = buildPath(from: bTypes, bPoints: bPoints)
        shapeLayer.path = mutablePath
        setBoundingBox()
    }
    
    public init(type: Int = 0) {
        mutablePath = CGMutablePath()
        firstPoint = CGPoint()
        lastPoint = CGPoint()
        boundingBox = CGRect()
        shapeLayer = CAShapeLayer()
        isMovable = true
        nodeType = 0
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Returns the d-component of the SVG string version of this node. */
    public func toSVG() -> String {
        guard let path = shapeLayer.path else { return "" }
        var result: String = ""
        
        let types = path.bezierPointsAndTypes
        
        for i in 0..<types.count {
            switch types[i].1 {
            case .moveToPoint:
                let newPoint = types[i].0[0]
                result += String(format: " M%.1lf %.1lf", newPoint.x, newPoint.y)
                break
            case .addLineToPoint:
                let newPoint = types[i].0[0]
                result += String(format: " L%.1lf %.1lf", newPoint.x, newPoint.y)
                break
            case .addQuadCurveToPoint:
                let controlPoint = types[i].0[0]
                let newPoint = types[i].0[1]
                result += String(format: " Q%.1lf %.1lf %.1lf %.1lf", controlPoint.x, controlPoint.y, newPoint.x, newPoint.y)
                break
            case .addCurveToPoint:
                let control1 = types[i].0[0]
                let control2 = types[i].0[1]
                let newPoint = types[i].0[2]
                result += String(format: " C%.1lf %.1lf %.1lf %.1lf %.1lf %.1lf", control1.x, control1.y, control2.x, control2.y, newPoint.x, newPoint.y)
                break
            case .closeSubpath:
                result += " Z"
                break
            }
        }
            
        return result
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Sets the first point on this node and moves there. */
    mutating func setInitialPoint(point: CGPoint) {
        firstPoint = point
    }
    
    
    /** Sets the last point and the current point and moves to the current point. */
    mutating func move(from: CGPoint, to: CGPoint, tool: CanvasTool) {
        lastPoint = to
        
        switch tool {
        case .pen:
            mutablePath.addQuadCurve(to: midpoint(a: from, b: to), control: from)
            break
        default:
            break
        }
    }
    
    
    /** Adds a new path to the curve and returns the bounding box of that path. */
    mutating func addPath(p1: CGPoint, p2: CGPoint, currentPoint: CGPoint, tool: CanvasTool) -> CGRect {
        switch tool {
        case .pen:
            let mid1 = midpoint(a: p1, b: p2)
            let mid2 = midpoint(a: currentPoint, b: p2)
            
            let subpath = CGMutablePath()
            subpath.move(to: mid1)
            subpath.addQuadCurve(to: mid2, control: p2)
            let bounds = subpath.boundingBox
            
            mutablePath.addPath(subpath)
            subpath.closeSubpath()
            return bounds
        case .line:
            return CGRect()
        case .rectangle:
            return CGRect()
        case .ellipse:
            return CGRect()
        default:
            return CGRect()
        }
    }
    
    
    /** Checks whether or not this node contains a certain point. */
    func contains(point: CGPoint, tool: CanvasTool, canvas: Canvas) -> Bool {
        switch tool {
        case .pen:
            return mutablePath.bezierPoints.contains(where: { p -> Bool in
                return abs(point.x - p.x) <= canvas.currentBrush.thickness && abs(point.y - p.y) <= canvas.currentBrush.thickness
            })
        case .line:
            let points = pointsOnLine(startPoint: firstPoint, endPoint: lastPoint)
            return points.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= canvas.currentBrush.thickness && abs(point.y - p.y) <= canvas.currentBrush.thickness }) || (mutablePath.bezierPoints.contains(where: { (p) -> Bool in return abs(point.x - p.x) <= canvas.currentBrush.thickness && abs(point.y - p.y) <= canvas.currentBrush.thickness }))
        case .rectangle:
            return false
        case .ellipse:
            let center = CGPoint(x: boundingBox.minX + boundingBox.width / 2, y: boundingBox.minY + boundingBox.height / 2)
            let radius = boundingBox.width / 2
            let dx = point.x - center.x
            let dy = point.y - center.y
            let dist = sqrt((dx ** 2) + (dy ** 2))
            
            if let layer = canvas.layer.hitTest(point) {
                return ((layer as! CAShapeLayer).path?.contains(point))!
            }
            return dist <= radius
        default:
            return false
        }
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *         OTHER        *
     *                      *
     ************************/
    
    /** Sets the rectangular bounding box of a curve. */
    mutating func setBoundingBox(rect: CGRect? = nil, absolute: Bool = false) {
        if rect != nil { boundingBox = rect!; return }
        if absolute == true {
            boundingBox = CGRect(x: self.firstPoint.x, y: self.firstPoint.y, width: abs(self.lastPoint.x - self.firstPoint.x), height: abs(self.lastPoint.y - self.firstPoint.y))
        } else {
            boundingBox = CGRect(x: self.firstPoint.x, y: self.firstPoint.y, width: self.lastPoint.x - self.firstPoint.x, height: self.lastPoint.y - self.firstPoint.y)
        }
    }
    
    
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
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NodeCodingKeys.self)
        try container.encode(firstPoint, forKey: NodeCodingKeys.nodeFirstPoint)
        try container.encode(lastPoint, forKey: NodeCodingKeys.nodeLastPoint)
        try container.encode(boundingBox, forKey: NodeCodingKeys.nodeBoundingBox)
        try container.encode(isMovable, forKey: NodeCodingKeys.nodeMovable)
        try container.encode(nodeType, forKey: NodeCodingKeys.nodeType)
        
        // Encode the bezier points and bezier types separately.
        let bezPoints = shapeLayer.path!.bezierPointsAndTypes.map { group in
            return group.0
        }
        let bezTypes = shapeLayer.path!.bezierPointsAndTypes.map { group in
            return group.1.rawValue
        }
        
        // Encode the rgba color values for the shape layer.
        if shapeLayer.fillColor == nil { try container.encode([-1,-1,-1,-1], forKey: NodeCodingKeys.nodeFill) }
        else { try container.encode(shapeLayer.fillColor?.rgba, forKey: NodeCodingKeys.nodeFill) }
        
        if shapeLayer.strokeColor == nil { try container.encode([-1,-1,-1,-1], forKey: NodeCodingKeys.nodeStroke) }
        else { try container.encode(shapeLayer.strokeColor?.rgba, forKey: NodeCodingKeys.nodeStroke) }
        
        
        try container.encode(bezPoints, forKey: NodeCodingKeys.nodeBezPoints)
        try container.encode(bezTypes, forKey: NodeCodingKeys.nodeBezTypes)
        try container.encode(shapeLayer.lineCap, forKey: NodeCodingKeys.nodeLineCap)
        try container.encode(shapeLayer.lineJoin, forKey: NodeCodingKeys.nodeLineJoin)
        try container.encode(shapeLayer.lineWidth, forKey: NodeCodingKeys.nodeLineWidth)
        try container.encode(shapeLayer.miterLimit, forKey: NodeCodingKeys.nodeMiter)
        try container.encode(shapeLayer.bounds, forKey: NodeCodingKeys.nodeBounds)
        try container.encode(shapeLayer.position, forKey: NodeCodingKeys.nodePosition)
    }
    
    
    /** Returns a copy of this node. */
    public func copy() -> Node {
        var n = Node()
        n.mutablePath = self.mutablePath.mutableCopy() ?? CGMutablePath()
        n.firstPoint = self.firstPoint
        n.lastPoint = self.lastPoint
        n.boundingBox = self.boundingBox
        n.shapeLayer = self.shapeLayer.mutableCopy() as? CAShapeLayer ?? CAShapeLayer()
        n.isMovable = self.isMovable
        n.nodeType = self.nodeType
        
        return n
    }
    
}
