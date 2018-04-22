//
//  Canvas+Other.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation

public extension Canvas {
    
    
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
        case CanvasTool.eyedropper: n = EyedropperNode(); break
        case CanvasTool.paint: n = PaintNode(); break
        }
        
        n.id = totalNodeCount
        n.brush = currentDrawingBrush
        return n
    }
    
    
}
