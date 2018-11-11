//
//  Brush.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/8/18.
//

import Foundation

/** A Brush defines the styling for how things should be drawn on the canvas. */
public struct Brush: Codable {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The stroke color of the brush. */
    public var strokeColor: UIColor
    
    /** The fill color of the brush. */
    public var fillColor: UIColor?
    
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
        a.strokeColor = .black
        a.fillColor = nil
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
        let container = try? decoder.container(keyedBy: BrushCodingKeys.self)
        thickness = try container?.decodeIfPresent(CGFloat.self, forKey: BrushCodingKeys.thickness) ?? 5
        opacity = try container?.decodeIfPresent(CGFloat.self, forKey: BrushCodingKeys.opacity) ?? 1
        miter = try container?.decodeIfPresent(CGFloat.self, forKey: BrushCodingKeys.miter) ?? 1
        shape = CGLineCap(rawValue: try container?.decodeIfPresent(Int32.self, forKey: BrushCodingKeys.shape) ?? 1) ?? .round
        joinStyle = CGLineJoin(rawValue: try container?.decodeIfPresent(Int32.self, forKey: BrushCodingKeys.join) ?? 1) ?? .round
        
        let sc = try container?.decodeIfPresent([CGFloat].self, forKey: BrushCodingKeys.strokeColor) ?? [0,0,0,1]
        let fc = try container?.decodeIfPresent([CGFloat].self, forKey: BrushCodingKeys.fillColor) ?? nil
        
        strokeColor = UIColor(red: sc[0]/255, green: sc[1]/255, blue: sc[2]/255, alpha: sc[3])
        if fc != nil { fillColor = UIColor(red: fc![0]/255, green: fc![1]/255, blue: fc![2]/255, alpha: fc![3]) }
        else { fillColor = nil }
    }
    
    /** Creates a basic Brush that is colored black, has a thickness of 2, and a round line cap. */
    public init() {
        strokeColor = UIColor.black
        fillColor = nil
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
        try container.encode(strokeColor.rgba, forKey: BrushCodingKeys.strokeColor)
        if fillColor != nil { try container.encode(fillColor!.rgba, forKey: BrushCodingKeys.fillColor) }
        try container.encode(thickness, forKey: BrushCodingKeys.thickness)
        try container.encode(opacity, forKey: BrushCodingKeys.opacity)
        try container.encode(miter, forKey: BrushCodingKeys.miter)
        try container.encode(shape.rawValue, forKey: BrushCodingKeys.shape)
        try container.encode(joinStyle.rawValue, forKey: BrushCodingKeys.join)
    }
    
}
