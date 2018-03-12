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
        guard let currLayer = currentLayer else { UIGraphicsEndImageContext(); return }
        
        if redraw {
            currLayer.drawImage = nil
            
            // Redraw each node in the current layer.
            for layer in layers {
                if layer.backgroundImage != nil { layer.backgroundImage.draw(in: layer.canvas.frame) }
                for node in layer.nodeArray { node.draw() }
            }
        } else {
            // Draw background image.
            if currLayer.backgroundImage != nil { currLayer.backgroundImage.draw(in: currLayer.canvas.frame) }
            
            // Draw the actual drawing image.
            currLayer.drawImage.draw(at: CGPoint.zero)
            currLayer.nextNode?.draw()
        }
        
        currLayer.drawImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    /** Creates the node that you are going to use to draw, with the current brush settings. */
    internal func createNodeWithCurrentBrush() -> Node {
        let n: Node
        
        switch currentDrawingTool! {
        case CanvasTool.pen: n = PenNode(); break
        case CanvasTool.eraser: n = EraserNode(); break
        case CanvasTool.line: n = LineNode(); break
        case CanvasTool.rectangle: n = RectangleNode(shouldFill: false); break
        case CanvasTool.rectangleFill: n = RectangleNode(shouldFill: true); break
        case CanvasTool.ellipse: n = EllipseNode(shouldFill: false); break
        case CanvasTool.ellipseFill: n = EllipseNode(shouldFill: true); break
        case CanvasTool.selection: n = SelectionNode(); break
        }
        
        n.id = totalNodeCount
        n.brush = currentDrawingBrush
        return n
    }
    
    
}
