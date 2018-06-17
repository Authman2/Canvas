//
//  Brush.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation


/** A Brush defines the styling for how things should be drawn on the canvas. */
public struct Brush: Codable {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The color of the brush. */
    public var color: UIColor
    
    /** The thickness of the brush. */
    public var thickness: CGFloat
    
    /** The opacity of the brush. Between 0 and 1. */
    public var opacity: CGFloat {
        didSet {
            if opacity > 1 { opacity = 1 }
            else if opacity < 0 { opacity = 0 }
        }
    }
    
    /** The miter limit of the brush. */
    public var miter: CGFloat {
        didSet {
            if miter > 1 { miter = 1 }
            else if miter < 0 { miter = 0 }
        }
    }
    
    /** The shape of the cap of the brush. */
    public var shape: CGLineCap
    
    /** The line join style. */
    public var joinStyle: CGLineJoin
    
    
    
    
    /** A default Brush to use. */
    public static let Default: Brush = {
        var a = Brush()
        a.color = .black
        a.thickness = 5
        a.opacity = 1
        a.miter = 1
        a.shape = CGLineCap.round
        a.joinStyle = CGLineJoin.round
        
        return a
    }()
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BrushCodingKeys.self)
        let colors = try container.decode([CGFloat].self, forKey: BrushCodingKeys.brushColor)
        color = UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: colors[3])
        thickness = try container.decode(CGFloat.self, forKey: BrushCodingKeys.brushThickness)
        opacity = try container.decode(CGFloat.self, forKey: BrushCodingKeys.brushOpacity)
        miter = try container.decode(CGFloat.self, forKey: BrushCodingKeys.brushMiter)
        let s = try container.decode(Int32.self, forKey: BrushCodingKeys.brushShape)
        let j = try container.decode(Int32.self, forKey: BrushCodingKeys.brushJoinStyle)
        shape = CGLineCap(rawValue: s) ?? .round
        joinStyle = CGLineJoin(rawValue: j) ?? .round
    }
    
    /** Creates a basic Brush that is colored black, has a thickness of 2, and a round line cap. */
    public init() {
        color = UIColor.black
        thickness = 2
        opacity = 1
        miter = 1
        shape = CGLineCap.round
        joinStyle = CGLineJoin.round
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BrushCodingKeys.self)
        try container.encode(color.rgba, forKey: BrushCodingKeys.brushColor)
        try container.encode(thickness, forKey: BrushCodingKeys.brushThickness)
        try container.encode(opacity, forKey: BrushCodingKeys.brushOpacity)
        try container.encode(miter, forKey: BrushCodingKeys.brushMiter)
        try container.encode(shape.rawValue, forKey: BrushCodingKeys.brushShape)
        try container.encode(joinStyle.rawValue, forKey: BrushCodingKeys.brushJoinStyle)
    }
    
}
