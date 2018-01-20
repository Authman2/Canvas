//
//  CanvasLayer.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/15/18.
//

import Foundation


/** A single layer that can be drawn on. The Canvas can have multiple layers which can be rearranged to have different drawings appear on top of or
 below others. */
public class CanvasLayer: CAShapeLayer, NSCopying {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The brush to use for drawing on this layer. */
    var brush: Brush
    
    /** Whether or not the layer should use anti-aliasing. */
    public var isAntiAliasEnabled: Bool
    
    /** The lines that are already drawn. */
    var lines: [(CGMutablePath, Brush)]
    var redos: [(CGMutablePath, Brush)]
    
    /** Whether the layer is drawing or not. */
    var drawing: Bool = true
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        self.brush = Brush.Default
        self.isAntiAliasEnabled = true
        self.lines = []
        self.redos = []
        super.init(coder: aDecoder)
        self.path = CGMutablePath()
        self.backgroundColor = UIColor.clear.cgColor
    }
    
    public override init() {
        self.brush = Brush.Default
        self.isAntiAliasEnabled = true
        self.lines = []
        self.redos = []
        super.init()
        self.path = CGMutablePath()
        self.backgroundColor = UIColor.clear.cgColor
    }
    
    public init(brush: Brush) {
        self.brush = brush
        self.isAntiAliasEnabled = true
        self.lines = []
        self.redos = []
        super.init()
        self.path = CGMutablePath()
        self.backgroundColor = UIColor.clear.cgColor
    }
    
    public override init(layer: Any) {
        self.brush = Brush.Default
        self.isAntiAliasEnabled = true
        self.lines = []
        self.redos = []
        super.init(layer: layer)
        self.path = CGMutablePath()
        self.backgroundColor = UIColor.clear.cgColor
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    public override func draw(in context: CGContext) {
        if drawing == true {
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
        } else {
            for path in lines {
                context.addPath(path.0)
                context.setLineCap(path.1.shape)
                context.setAlpha(path.1.opacity)
                context.setLineWidth(path.1.thickness)
                context.setLineJoin(path.1.joinStyle)
                context.setFlatness(path.1.flatness)
                context.setMiterLimit(path.1.miter)
                context.setStrokeColor(path.1.color.cgColor)
                context.setShouldAntialias(self.isAntiAliasEnabled)
                context.setAllowsAntialiasing(self.isAntiAliasEnabled)
                context.strokePath()
            }
        }
    }
    
    
    
    func _undo() {
        drawing = false
        
        if !lines.isEmpty {
            let last = lines.removeLast()
            redos.append(last)
            setNeedsDisplay()
        }
    }
    
    func _redo() {
        drawing = false
        
        if !redos.isEmpty {
            let last = redos.removeLast()
            lines.append(last)
            setNeedsDisplay()
        }
    }
    
    func _clear() {
        drawing = false
        lines.append((path! as! CGMutablePath, brush))
        path = CGMutablePath()
    }
    
    
    
    
    
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = CanvasLayer()
        copy.brush = self.brush
        copy.path = self.path
        copy.frame = self.frame
        copy.bounds = self.bounds
        copy.isAntiAliasEnabled = self.isAntiAliasEnabled
        return copy
    }
    
    public override func mutableCopy() -> Any {
        let copy = CanvasLayer()
        copy.brush = self.brush
        copy.path = self.path
        copy.frame = self.frame
        copy.bounds = self.bounds
        copy.isAntiAliasEnabled = self.isAntiAliasEnabled
        return copy
    }
}
