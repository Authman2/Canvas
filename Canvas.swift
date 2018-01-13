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
    var _path: CGMutablePath
    
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
        _path = CGMutablePath()
        super.init(coder: aDecoder)
    }
    
    /** Creates a blank canvas. */
    public init() {
        _path = CGMutablePath()
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
    public func undo() { undoRedoManager._undo(path: &_path, view: self) }
    
    
    /** Handles putting back the last line that was drawn on the Canvas. */
    public func redo() { undoRedoManager._redo(path: &_path, view: self) }
    
    
    /** Clears the Canvas completly. */
    public func clear() { _path = CGMutablePath(); setNeedsDisplay() }
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    public override func draw(_ rect: CGRect) {
        backgroundColor?.set()
        UIRectFill(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(_path)
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

