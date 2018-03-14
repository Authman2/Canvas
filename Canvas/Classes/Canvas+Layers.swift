//
//  Canvas+Layers.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation


public extension Canvas {
    
    /** Adds a new drawing layer to the canvas. By default the layer is added above the current layer. */
    public func addDrawingLayer(newLayer: CanvasLayer, position: LayerPosition = .above) {
        if position == .above {
            layers.append(newLayer)
        } else {
            if layers.count > 0 {
                layers.insert(newLayer, at: self.currentCanvasLayer)
            } else {
                layers = [newLayer]
            }
        }
    }
    
    
    /** Switches the drawing to the specified layer. If an invalid layer index is put in, nothing will happen. */
    public func switchLayer(to: Int) {
        if to >= layers.count { currentCanvasLayer = layers.count - 1 }
        else if to < 0 { currentCanvasLayer = 0 }
        else { currentCanvasLayer = to }
    }
    
    
    /** Moves one layer to a new location. */
    public func moveLayer(at: Int, toPosition to: Int) {
        if layers.count == 0 { return }
        if at >= layers.count { return }
        
        var t = to
        if to >= layers.count { t = layers.count - 1 }
        
        let layer = layers[at]
        layers.remove(at: at)
        layers.insert(layer, at: t)
        
        let before = currentCanvasLayer
        currentCanvasLayer = at
        layers[at].updateLayer(redraw: false)
        setNeedsDisplay()
        currentCanvasLayer = before
    }
    
    
    /** Swaps the positions of two layers using the indexes of those layers. */
    public func swapLayers(first: Int, second: Int) {
        if layers.count == 0 { return }
        if first >= layers.count { return }
        if second >= layers.count { return }
        
        layers.swapAt(first, second)
        
        let before = currentCanvasLayer
        currentCanvasLayer = second
        layers[first].updateLayer(redraw: false)
        layers[second].updateLayer(redraw: false)
        setNeedsDisplay()
        currentCanvasLayer = before
    }
    
    
    /** Removes a layer at the given index. */
    public func removeLayer(at: Int) {
        if layers.count == 0 { return }
        if at < 0 && at >= layers.count { return }
        
        if currentCanvasLayer == layers.count { currentCanvasLayer = layers.count - 1 }
        layers.remove(at: at)
        
        layers[at].updateLayer(redraw: false)
        setNeedsDisplay()
    }    
    
    
    /** Hides the layer at the given index. */
    public func hideLayer(at: Int) {
        if at >= layers.count { return }
        if at < 0 { return }
        
        layers[at].isVisible = false
        
//        updateDrawing(redraw: false)
        setNeedsDisplay()
    }
    
    
    /** Makes the layer at the given index visible. */
    public func showLayer(at: Int) {
        if at >= layers.count { return }
        if at < 0 { return }
        
        layers[at].isVisible = true
        
//        updateDrawing(redraw: false)
        setNeedsDisplay()
    }
    
    
    /** Locks a layer so that the user cannot draw on it. */
    public func lockLayer(at: Int) {
        if layers.count == 0 { return }
        if at >= layers.count { return }
        
        layers[at].allowsDrawing = false
    }
    
    
    /** Unlocks a layer so that the user can draw on it. */
    public func unlockLayer(at: Int) {
        if layers.count == 0 { return }
        if at >= layers.count { return }
        
        layers[at].allowsDrawing = true
    }
    
    
    
}
