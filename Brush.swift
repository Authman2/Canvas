//
//  Brush.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation


/** A Brush defines a way to draw on a Canvas. It contains a variety of properties that the Canvas then uses
 to draw lines and shapes. */
public class Brush {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The color of the brush. */
    public var color: UIColor
    
    /** The thickness of the brush. */
    public var thickness: CGFloat
    
    /** The opacity of the brush. */
    public var opacity: CGFloat {
        didSet {
            if opacity > 1 { opacity = 1 }
            else if opacity < 0 { opacity = 0 }
        }
    }
    
    /** The flatness of the brush. */
    public var flatness: CGFloat
    
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
        a.thickness = 2
        a.opacity = 1
        a.flatness = 0.1
        a.miter = 1
        a.shape = CGLineCap.round
        a.joinStyle = CGLineJoin.round
        
        return a
    }()
    
    /** A brush that can be used as an eraser. The user can always create their own eraser, but here is one that works right out of the box. */
    public static let Eraser: Brush = {
        let a = Brush()
        a.color = .clear
        a.thickness = 2
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
    
    /** Creates a basic Brush that is colored black, has a thickness of 2, and a round line cap. */
    public init() {
        color = UIColor.black
        thickness = 2
        opacity = 1
        flatness = 0.1
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

