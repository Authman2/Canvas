//
//  Node.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

/** A point, line, shape, etc. that exists on a layer of the canvas. */
public class Node: Codable {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS
    
    /** What type of node this is. */
    internal var type: CanvasTool!
    
    
    // -- PUBLIC VARS
    
    /** The points that make up this node. */
    public var points: [[CGPoint]] = []
    
    /** The instructions used to draw the points. */
    public var instructions: [CGPathElementType] = []
    
    /** The brush that this node uses for styling. */
    public var brush: Brush = .Default
    
    
    // -- COMPUTED PROPERTIES
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: NodeCodingKeys.self)
        let _type = try container?.decodeIfPresent(Int.self, forKey: NodeCodingKeys.type) ?? 0
        let _instructions = try container?.decodeIfPresent([Int32].self, forKey: NodeCodingKeys.instructions)
        
        type = CanvasTool(rawValue: _type) ?? .pen
        points = try container?.decodeIfPresent([[CGPoint]].self, forKey: NodeCodingKeys.points) ?? []
        instructions = _instructions?.map({ (rv) -> CGPathElementType in return CGPathElementType(rawValue: rv) ?? .moveToPoint }) ?? []
        brush = try container?.decodeIfPresent(Brush.self, forKey: NodeCodingKeys.brush) ?? .Default
    }
    
    public init(type: CanvasTool) {
        self.type = type
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NodeCodingKeys.self)
        try container.encode(type.rawValue, forKey: NodeCodingKeys.type)
        try container.encode(points, forKey: NodeCodingKeys.points)
        try container.encode(instructions.map { return $0.rawValue }, forKey: NodeCodingKeys.instructions)
        try container.encode(brush, forKey: NodeCodingKeys.brush)
    }
    
}
