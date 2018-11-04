//
//  Canvas+Other.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

extension Canvas {
    
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
    
    func handleSelection(with selectionArea: CGRect) {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        if currLayer.allowsDrawing == false { return }
        currLayer.selectedNodes.removeAll()
        
        // Find the nodes that are within the selection box.
        for node in currLayer.drawings {
            let path = build(from: node.points, using: node.instructions, tool: node.type)
            
            if selectionArea.contains(path.boundingBox) {
                currLayer.selectedNodes.append(node)
            }
        }
        
        // Delegate.
        self.delegate?.didSelectNodes(on: self, on: currLayer, selectedNodes: currLayer.selectedNodes)
    }
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
