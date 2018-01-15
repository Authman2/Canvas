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
    
    /** The brush to use for drawing on this layer. */
    var brush: Brush
    
    /** Whether or not the layer should use anti-aliasing. */
    public var isAntiAliasEnabled: Bool
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        self.brush = Brush.Default
        self.isAntiAliasEnabled = true
        super.init(coder: aDecoder)
        self.path = CGMutablePath()
    }
    
    public override init() {
        self.brush = Brush.Default
        self.isAntiAliasEnabled = true
        super.init()
        self.path = CGMutablePath()
        self.backgroundColor = UIColor.clear.cgColor
    }
    
    public init(brush: Brush) {
        self.brush = brush
        self.isAntiAliasEnabled = true
        super.init()
        self.path = CGMutablePath()
        self.backgroundColor = UIColor.clear.cgColor
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    public override func draw(in context: CGContext) {
        context.addPath(self.path!)
        context.setLineCap(self.brush.shape)
        context.setAlpha(self.brush.opacity)
        context.setLineWidth(self.brush.thickness)
        context.setLineJoin(self.brush.joinStyle)
        context.setFlatness(self.brush.flatness)
        context.setMiterLimit(self.brush.miter)
        context.setStrokeColor(self.brush.color.cgColor)
    
        context.setShouldAntialias(self.isAntiAliasEnabled)
        context.setAllowsAntialiasing(self.isAntiAliasEnabled)
    
        context.strokePath()
    }
    
    
    /** Undoes the last stroke. */
    func _undo() {
        
    }
    
    
    
}
