//
//  CanvasLayer.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/15/18.
//

import Foundation


/** A single layer that can be drawn on. The Canvas can have multiple layers which can be rearranged to have different drawings appear on top of or
 below others. */
public class CanvasLayer: CAShapeLayer {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    

    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        path = CGMutablePath()
    }
    
    public override init() {
        super.init()
        path = CGMutablePath()
        backgroundColor = UIColor.white.cgColor
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    public override func draw(in context: CGContext) {
        context.addPath(self.path!)
        context.setLineCap(Brush.Default.shape)
        context.setAlpha(Brush.Default.opacity)
        context.setLineWidth(Brush.Default.thickness)
        context.setLineJoin(Brush.Default.joinStyle)
        context.setFlatness(Brush.Default.flatness)
        context.setMiterLimit(Brush.Default.miter)
        context.setStrokeColor(Brush.Default.color.cgColor)
        
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        
        context.strokePath()
    }
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
