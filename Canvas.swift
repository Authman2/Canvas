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
    
    /** All of the layers on the Canvas. */
    var layers: [CanvasLayer]!
    var currentLayer: Int = 0
    
    /** The delegate. */
    public var delegate: CanvasDelegate?
    
    
    // Canvas Settings
    
    /** The brush that is currently being used to draw on the Canvas. */
    public var currentBrush: Brush!
    
    /** Whether or not the Canvas should create a default layer. True by default. */
    public var shouldCreateDefaultLayer: Bool!
    
    /** Enable/Disable drawing on the entire Canvas. */
    public var allowDrawing: Bool!
    
    
    
    
    
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
        allowDrawing = true
        currentBrush = Brush.Default
        shouldCreateDefaultLayer = true
        super.init(frame: CGRect.zero)
        clipsToBounds = true
    }
    
    public override func layoutMarginsDidChange() {
        if layers.count == 0 && shouldCreateDefaultLayer {
            // Create the default layer.
            let defL = CanvasLayer()
            addDrawingLayer(layer: defL)
        }
    }
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    // Undo/Redo/Clear
    
    /** Undos the last line/shape that was drawn on the Canvas. */
    public func undo() {
        layers[currentLayer]._undo()
    }
    
    
    /** Handles putting back the last line that was drawn on the Canvas. */
    public func redo() {
        layers[currentLayer]._redo()
    }
    
    
    /** Clears the Canvas completely. */
    public func clear() {
        layers[currentLayer]._clear()
    }
    
    
    
    // Layers
    
    /** Adds a new layer to the Canvas and sets that layer to the current one. */
    public func addDrawingLayer(layer l: CanvasLayer) {
        l.frame = bounds
        l.bounds = bounds
        l.brush = currentBrush
        layers.append(l)
        self.layer.insertSublayer(l, above: self.layer)
        currentLayer = layers.count - 1
    }
    
    
    /** Switches to the layer at the specified index. */
    public func switchLayer(to: Int) {
        if to > layers.count { currentLayer = layers.count - 1 }
        else if to < 0 { currentLayer = 0 }
        else { currentLayer = to }
    }
    
    
    /** Moves the layer at the given index to a different position, then switches to that layer. */
    public func moveLayer(at: Int, toPosition to: Int) {
        let layer = layers[at]
        layers.remove(at: at)
        layers.insert(layer, at: to)
        switchLayer(to: to)
    }
    
    
    /** Removes the layer at the given index. */
    public func removeLayer(at: Int) {
        layers.remove(at: at)
        layer.sublayers?.remove(at: at)
        currentLayer = 0
    }
    
    
    /** Hides the layer at the given index. */
    public func hideLayer(at: Int) {
        if at < layers.count && at >= 0 {
            layers[at].isHidden = true
        }
    }
    
    
    /** Shows the layer at the given index. Only necessary after calling "hideLayer." */
    public func showLayer(at: Int) {
        if at < layers.count && at >= 0 {
            layers[at].isHidden = false
        }
    }
    
    
    /** Returns the array of all CanvasLayers. */
    public func getLayers() -> [CanvasLayer] {
        return layers
    }
    
    
    /** Returns the index of the current layer. */
    public func getCurrentLayer() -> Int {
        return currentLayer
    }
    
    
    /** Returns the current layer's object. */
    public func getCurrentLayer() -> CanvasLayer {
        return layers[currentLayer]
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        DRAWING       *
     *                      *
     ************************/
    
    /** Draws on the current layer. */
    func drawOnLayer(subpath: CGMutablePath, drawBox: CGRect) {
        if !allowDrawing { return }
        
        
        UIGraphicsBeginImageContext(frame.size)
        
        layers[currentLayer].brush = currentBrush
        (layers[currentLayer].path as! CGMutablePath).addPath(subpath)
        layers[currentLayer].setNeedsDisplay(drawBox)
        
        UIGraphicsEndImageContext()
    }
    
    
    
    
}

