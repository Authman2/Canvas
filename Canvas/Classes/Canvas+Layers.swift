//
//  Canvas+Layers.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

public extension Canvas {
    
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
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Adds a new layer to the canvas. */
    public func addLayer(newLayer nl: CanvasLayer, position: LayerPosition) {
        if self._canvasLayers.count == 0 {
            self._canvasLayers = [nl]
            return
        }
        
        switch position {
        case .above:
            let insertIndex = self._currentCanvasLayer == 0 ? 0 : self._currentCanvasLayer
            self._canvasLayers.insert(nl, at: insertIndex)
            break
        case .below:
            self._canvasLayers.insert(nl, at: self._currentCanvasLayer+1)
            break
        }
    }
    
    
    /** Removes a layer from the canvas. */
    public func removeLayer(at index: Int) {
        if self._canvasLayers.count == 0 { return }
        if index < 0 || index >= self._canvasLayers.count { return }
        
        self._canvasLayers.remove(at: index)
        
        if _currentCanvasLayer >= self._canvasLayers.count {
            self._currentCanvasLayer = self._canvasLayers.count - 1
        }
        
        setNeedsDisplay()
    }
    
    
    /** Switches the drawing to the specified layer. If an invalid layer index is put in, nothing will happen. */
    public func switchLayer(to: Int) {
        if to >= _canvasLayers.count { _currentCanvasLayer = _canvasLayers.count - 1 }
        else if to < 0 { _currentCanvasLayer = 0 }
        else { _currentCanvasLayer = to }
    }
    
    
    /** Moves one layer to a new location. */
    public func moveLayer(at: Int, toPosition to: Int) {
        if _canvasLayers.count == 0 { return }
        if at >= _canvasLayers.count { return }
        
        var t = to
        if to >= _canvasLayers.count { t = _canvasLayers.count - 1 }
        
        let layer = _canvasLayers[at]
        _canvasLayers.remove(at: at)
        _canvasLayers.insert(layer, at: t)
        
        let before = _currentCanvasLayer
        _currentCanvasLayer = at
        setNeedsDisplay()
        _currentCanvasLayer = before
    }
    
    
    /** Swaps the positions of two layers using the indexes of those layers. */
    public func swapLayers(first: Int, second: Int) {
        if _canvasLayers.count == 0 { return }
        if first >= _canvasLayers.count { return }
        if second >= _canvasLayers.count { return }
        
        _canvasLayers.swapAt(first, second)
        
        let before = _currentCanvasLayer
        _currentCanvasLayer = second
        setNeedsDisplay()
        _currentCanvasLayer = before
    }
    
    
    /** Hides the layer at the given index. */
    public func hideLayer(at: Int) {
        if at >= _canvasLayers.count { return }
        if at < 0 { return }
        
        _canvasLayers[at].isVisible = false
        
        setNeedsDisplay()
    }
    
    
    /** Makes the layer at the given index visible. */
    public func showLayer(at: Int) {
        if at >= _canvasLayers.count { return }
        if at < 0 { return }
        
        _canvasLayers[at].isVisible = true
        
        setNeedsDisplay()
    }
    
    
    /** Locks a layer so that the user cannot draw on it. */
    public func lockLayer(at: Int) {
        if _canvasLayers.count == 0 { return }
        if at >= _canvasLayers.count { return }
        
        _canvasLayers[at].allowsDrawing = false
    }
    
    
    /** Unlocks a layer so that the user can draw on it. */
    public func unlockLayer(at: Int) {
        if _canvasLayers.count == 0 { return }
        if at >= _canvasLayers.count { return }
        
        _canvasLayers[at].allowsDrawing = true
    }
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
