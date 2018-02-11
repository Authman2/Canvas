//
//  Canvas+Other.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation

public extension Canvas {
    
    /** Updates the image with new changes. */
    func updateDrawing(redraw: Bool) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        
        if redraw {
            self.drawingImage = nil
            
            for node in self.nodeArray {
                (node as! Node).draw()
            }
            
        } else {
            self.drawingImage.draw(at: CGPoint.zero)
            self.nextNode?.draw()
        }
        
        self.drawingImage = UIGraphicsGetImageFromCurrentImageContext()
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
