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
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
