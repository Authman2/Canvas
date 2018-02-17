//
//  EraserTool.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/9/18.
//

import Foundation


/** A standard eraser tool for erasing a drawing on the canvas. */
class EraserNode: PenNode {
    
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
    
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        context.addPath(path)
        context.setLineCap(brush.shape)
        context.setLineJoin(brush.joinStyle)
        context.setLineWidth(brush.thickness)
        context.setMiterLimit(brush.miter)
        context.setBlendMode(.clear)
        context.setFlatness(brush.flatness)
        context.strokePath()
        context.restoreGState()
    }
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}

