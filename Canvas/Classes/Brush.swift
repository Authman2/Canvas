//
//  Brush.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/8/18.
//

import Foundation

/** A Brush defines the styling for how things should be drawn on the canvas. */
public struct Brush {
    
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
    
}
