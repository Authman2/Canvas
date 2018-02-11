//
//  Canvas+Other.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation

public extension Canvas {
    
    /** Updates the image with new changes. */
    internal func updateDrawing(redraw: Bool) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        
        if redraw {
            currentLayer?.drawImage = nil
            
            // Draw each node in the current layer.
            if let l = currentLayer { for node in l.nodeArray { (node as! Node).draw() } }
        } else {
            currentLayer?.drawImage.draw(at: CGPoint.zero)
            currentLayer?.nextNode?.draw()
        }
        
        currentLayer?.drawImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    
    
    /** Returns the node that you are going to use to draw, with the current brush settings. */
    internal func getNodeWithCurrentBrush() -> Node {
        let n: Node
        
        switch currentTool! {
        case CanvasTool.pen: n = PenNode(); break
        case CanvasTool.eraser: n = EraserNode(); break
        }
        
        n.brush = self.currentBrush
        return n
    }
    
    
}