//
//  Canvas.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation

public class Canvas: UIView {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // The last few points touching the screen.
    var currentPoint: CGPoint!
    var lastPoint: CGPoint!
    var lastLastPoint: CGPoint!
    
    /** The path used to draw the curves. */
    var tempPath: CGMutablePath
    var lines: [(CGMutablePath, Brush)]
    var redos: [(CGMutablePath, Brush)]
    var drawing = false
    
    /** The manager for undo and redo operations. */
    var undoRedoManager: UndoRedoManager!
    
    /** The delegate. */
    public var delegate: CanvasDelegate?
    
    
    
    // Canvas Settings
    
    /** The brush that is currently being used to draw on the Canvas. */
    public var currentBrush: Brush!
    
    /** Whether or not anti-aliasing should be used when drawing. Default is false. */
    public var isAntiAliasEnabled: Bool!
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        tempPath = CGMutablePath()
        lines = []
        redos = []
        super.init(coder: aDecoder)
    }
    
    /** Creates a blank canvas. */
    public init() {
        tempPath = CGMutablePath()
        lines = []
        redos = []
        undoRedoManager = UndoRedoManager()
        isAntiAliasEnabled = false
        currentBrush = Brush.Default
        
        super.init(frame: CGRect.zero)
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    // Undo/Redo/Clear
    
    /** Undos the last line/shape that was drawn on the Canvas. */
    public func undo() {
        drawing = false
        redos.append(lines.removeLast())
        setNeedsDisplay()
        print("\(lines.count)")
    }
    
    
    /** Handles putting back the last line that was drawn on the Canvas. */
    public func redo() {
        drawing = false
        lines.append(redos.removeLast())
        setNeedsDisplay()
        print("\(lines.count)")
    }
    
    
    /** Clears the Canvas completly. */
    public func clear() {
        
    }
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public override func draw(_ rect: CGRect) {
        backgroundColor?.set()
        UIRectFill(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        if !drawing {
            for path in lines {
                context?.addPath(path.0)
                context?.setLineCap(path.1.shape)
                context?.setAlpha(path.1.opacity)
                context?.setLineWidth(path.1.thickness)
                context?.setLineJoin(path.1.joinStyle)
                context?.setFlatness(path.1.flatness)
                context?.setMiterLimit(path.1.miter)
                context?.setStrokeColor(path.1.color.cgColor)
                
                context?.setShouldAntialias(self.isAntiAliasEnabled)
                context?.setAllowsAntialiasing(self.isAntiAliasEnabled)
                
                context?.strokePath()
            }
        } else {
            context?.addPath(tempPath)
            context?.setLineCap(currentBrush.shape)
            context?.setAlpha(currentBrush.opacity)
            context?.setLineWidth(currentBrush.thickness)
            context?.setLineJoin(currentBrush.joinStyle)
            context?.setFlatness(currentBrush.flatness)
            context?.setMiterLimit(currentBrush.miter)
            context?.setStrokeColor(currentBrush.color.cgColor)
            
            context?.setShouldAntialias(self.isAntiAliasEnabled)
            context?.setAllowsAntialiasing(self.isAntiAliasEnabled)
            
            context?.strokePath()
        }
    }
    
    
    
    
}

