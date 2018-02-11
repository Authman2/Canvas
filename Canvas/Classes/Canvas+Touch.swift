//
//  Canvas+Touch.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation

public extension Canvas {
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Cleans up the line when you finish drawing a line. */
    func finishDrawingNode() {
        self.updateDrawing(redraw: false)
        self.redos.removeAllObjects()
        self.delegate?.didEndDrawing(self)
        self.nextNode = nil
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        TOUCHES       *
     *                      *
     ************************/
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Get the first touch point.
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Init (or reinit) the bezier curve. Makes sure the current tool always draws something.
        self.nextNode = getNodeWithCurrentBrush()
        
        // Add to arrays and set initial point.
        self.nodeArray.add(self.nextNode!)
        self.nextNode?.setInitialPoint(point: currentPoint)
        
        // Call delegate.
        delegate?.didBeginDrawing(self)
    }
    
    
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Collect touches.
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Draw based on the current tool.
        if currentTool == CanvasTool.pen || currentTool == CanvasTool.eraser {
            var boundingBox = self.nextNode?.addPathLastLastPoint(p1: lastLastPoint, p2: lastPoint, currentPoint: currentPoint) ?? CGRect()
            
            boundingBox.origin.x -= (self.nextNode?.brush.thickness ?? 5) * 2.0;
            boundingBox.origin.y -= (self.nextNode?.brush.thickness ?? 5) * 2.0;
            boundingBox.size.width += (self.nextNode?.brush.thickness ?? 5) * 4.0;
            boundingBox.size.height += (self.nextNode?.brush.thickness ?? 5) * 4.0;
            
            setNeedsDisplay(boundingBox)
        }
        else {
            self.nextNode?.move(from: lastPoint, to: currentPoint)
            setNeedsDisplay()
        }
    }
    
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Make sure the point is recorded.
        touchesMoved(touches, with: event)
        
        // Finish drawing.
        self.finishDrawingNode()
    }
    
    
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Make sure the point is recorded.
        touchesEnded(touches, with: event)
    }
    
}



