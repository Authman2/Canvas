//
//  Canvas+Layers.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation


/** This extension handles interacting with the layers of the canvas.
 
 Add Layer:
 - When adding a layer you can choose to add it either above or below the current layer.
 - Adding above looks like this:
    [* LAYER 1] ----> [LAYER 2]
                    [* LAYER 1]
    So you see that the array of layers inserts the new layer before the one at the current position.
 
 - Adding below looks like this:
    [* LAYER 1] ----> [* LAYER 1]
    [LAYER 2]         [LAYER 2]
                      [LAYER 3]
    And you can see here that layer 2 gets inserted directly after the current layer.
 - Adding layers like this makes it very easy to understand what is going on visually. Looking at an array
   representation as a vertical line, we see that the first element (the top) is clearly the top layer of the
   canvas, while the last item (the bottom) is clearly the bottom layer of the canvas.
 - Also, don't forget to update the current layer variable whenever you add a layer.
 
 
 */
public extension Canvas {
    
    /** Adds a new drawing layer to the canvas. By default the layer is added above the current layer. */
    public func addDrawingLayer(newLayer nl: CanvasLayer, position: LayerPosition = .above) {
        
        // If there are no layers yet, just make the array of one object.
        if layers.count == 0 { layers = [nl]; return }
        
        switch position {
        case .above:
            let insertIndex = currentLayerIndex == 0 ? 0 : (currentLayerIndex)
            layers.insert(nl, at: insertIndex)
            currentCanvasLayer += 1
            break
        case .below:
            layers.insert(nl, at: currentLayerIndex+1)
            break
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
        setNeedsDisplay()
        currentCanvasLayer = before
    }
    
    
    /** Removes a layer at the given index. */
    public func removeLayer(at: Int) {
        if layers.count == 0 { return }
        if at < 0 && at >= layers.count { return }
        
        if currentCanvasLayer == layers.count { currentCanvasLayer = layers.count - 1 }
        layers.remove(at: at)
        
        setNeedsDisplay()
    }    
    
    
    /** Hides the layer at the given index. */
    public func hideLayer(at: Int) {
        if at >= layers.count { return }
        if at < 0 { return }
        
        layers[at].isVisible = false
        
        setNeedsDisplay()
    }
    
    
    /** Makes the layer at the given index visible. */
    public func showLayer(at: Int) {
        if at >= layers.count { return }
        if at < 0 { return }
        
        layers[at].isVisible = true
        
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
