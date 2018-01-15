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
    
    /** Whether or not the Canvas is currently in drawing mode. */
    var drawing = false
    
    /** All of the layers on the Canvas. */
    var layers: [CanvasLayer]!
    var currentLayer: Int = 0
    
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
        super.init(coder: aDecoder)
    }
    
    /** Creates a blank canvas. */
    public init() {
        layers = []
        undoRedoManager = UndoRedoManager()
        isAntiAliasEnabled = false
        currentBrush = Brush.Default
        
        super.init(frame: CGRect.zero)
        
        clipsToBounds = true
    }
    
    public override func layoutMarginsDidChange() {
        // Create the default layer.
        let defL = CanvasLayer()
        addDrawingLayer(layer: defL)
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    // Undo/Redo/Clear
    
    /** Undos the last line/shape that was drawn on the Canvas. */
    public func undo() {
        undoRedoManager._undo(drawing: &drawing, view: self)
    }
    
    
    /** Handles putting back the last line that was drawn on the Canvas. */
    public func redo() {
        undoRedoManager._redo(drawing: &drawing, view: self)
        
//        let sub = CAShapeLayer()
//        sub.frame = frame
//        sub.backgroundColor = UIColor.white.cgColor
//        sub.opacity = 0.8
//        let a = CGMutablePath()
//        a.move(to: CGPoint(x: 50, y: 50))
//        a.addLine(to: CGPoint(x: 300, y: 500))
//        let ctx = UIGraphicsGetCurrentContext()
//        ctx?.setStrokeColor(UIColor.green.cgColor)
//        ctx?.strokePath()
//        sub.contents = a
//        layer.insertSublayer(sub, above: layer)
//        sub.zPosition = 0
//        setNeedsDisplay()
    }
    
    
    /** Clears the Canvas completly. */
    public func clear() {
        drawing = true
        undoRedoManager.undoStack.push((layers[currentLayer].path! as! CGMutablePath, currentBrush))
        layers[currentLayer].path! = CGMutablePath()
        setNeedsDisplay()
    }
    
    
    
    // Layers
    
    /** Adds a new layer to the Canvas and sets that layer to the current one. */
    public func addDrawingLayer(layer l: CanvasLayer) {
        l.frame = bounds
        l.bounds = bounds
        layers.append(l)
        self.layer.insertSublayer(l, above: self.layer)
        currentLayer = layers.count - 1
    }
    
    
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    /** Draws on the current layer. */
    func drawOnLayer(subpath: CGMutablePath, drawBox: CGRect) {
        UIGraphicsBeginImageContext(frame.size)
        
        (layers[currentLayer].path as! CGMutablePath).addPath(subpath)
        layers[currentLayer].setNeedsDisplay(drawBox)
        
        UIGraphicsEndImageContext()
    }
    
    
    
    
}

