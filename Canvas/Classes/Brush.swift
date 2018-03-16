//
//  Brush.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation


/** A Brush defines the styling for how things should be drawn on the canvas. */
public class Brush: NSObject, NSCoding  {
    
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
    
    /** The flatness of the brush. Between 0 and 1. */
    public var flatness: CGFloat {
        didSet {
            if flatness > 1 { flatness = 1 }
            else if flatness < 0 { flatness = 0 }
        }
    }
    
    /** The miter limit of the brush. */
    public var miter: CGFloat
    
    /** The shape of the cap of the brush. */
    public var shape: CGLineCap
    
    /** The line join style. */
    public var joinStyle: CGLineJoin
    
    
    
    
    /** A default Brush to use. */
    public static let Default: Brush = {
        let a = Brush()
        a.color = .black
        a.thickness = 5
        a.opacity = 1
        a.flatness = 0.1
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
    
    public required init?(coder aDecoder: NSCoder) {
        color = aDecoder.decodeObject(forKey: "canvas_brush_color") as! UIColor
        thickness = aDecoder.decodeObject(forKey: "canvas_brush_thickness") as! CGFloat
        opacity = aDecoder.decodeObject(forKey: "canvas_brush_opacity") as! CGFloat
        flatness = aDecoder.decodeObject(forKey: "canvas_brush_flatness") as! CGFloat
        miter = aDecoder.decodeObject(forKey: "canvas_brush_miter") as! CGFloat
        shape = CGLineCap(rawValue: aDecoder.decodeInt32(forKey: "canvas_brush_shape")) ?? CGLineCap.round
        joinStyle = CGLineJoin(rawValue: aDecoder.decodeInt32(forKey: "canvas_brush_joinStyle")) ?? CGLineJoin.round
    }
    
    /** Creates a basic Brush that is colored black, has a thickness of 2, and a round line cap. */
    public override init() {
        color = UIColor.black
        thickness = 2
        opacity = 1
        flatness = 0.1
        miter = 1
        shape = CGLineCap.round
        joinStyle = CGLineJoin.round
        super.init()
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    public override func copy() -> Any {
        let b = Brush()
        b.color = color
        b.thickness = thickness
        b.opacity = opacity
        b.flatness = flatness
        b.miter = miter
        b.shape = shape
        b.joinStyle = joinStyle
        
        return b
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(color, forKey: "canvas_brush_color")
        aCoder.encode(thickness, forKey: "canvas_brush_thickness")
        aCoder.encode(opacity, forKey: "canvas_brush_opacity")
        aCoder.encode(flatness, forKey: "canvas_brush_flatness")
        aCoder.encode(miter, forKey: "canvas_brush_miter")
        aCoder.encode(shape.rawValue, forKey: "canvas_brush_shape")
        aCoder.encode(joinStyle.rawValue, forKey: "canvas_brush_joinStyle")
    }
    
}
