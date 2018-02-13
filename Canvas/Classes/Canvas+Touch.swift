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
    private func finishDrawingNode() {
        self.updateDrawing(redraw: false)
        self.redos.removeAllObjects()
        self.delegate?.didEndDrawing(on: self, withTool: currentTool)
        currentLayer?.nextNode = nil
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *        TOUCHES       *
     *                      *
     ************************/
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing.
        if currLayer.allowsDrawing == false { return }
        
        // Get the first touch point.
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Init (or reinit) the bezier curve. Makes sure the current tool always draws something.
        currLayer.nextNode = createNodeWithCurrentBrush()
        
        // Add to arrays and set initial point.
        currLayer.nodeArray.add(currLayer.nextNode!)
        currLayer.nextNode?.setInitialPoint(point: currentPoint)
        
        // Call delegate.
        delegate?.didBeginDrawing(on: self, withTool: currentTool)
    }
    
    
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing.
        if currLayer.allowsDrawing == false { return }
        
        // Collect touches.
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Draw based on the current tool.
        if currentTool == CanvasTool.pen || currentTool == CanvasTool.eraser {
            var boundingBox = currLayer.nextNode?.addPathLastLastPoint(p1: lastLastPoint, p2: lastPoint, currentPoint: currentPoint) ?? CGRect()
            
            boundingBox.origin.x -= (currLayer.nextNode?.brush.thickness ?? 5) * 2.0;
            boundingBox.origin.y -= (currLayer.nextNode?.brush.thickness ?? 5) * 2.0;
            boundingBox.size.width += (currLayer.nextNode?.brush.thickness ?? 5) * 4.0;
            boundingBox.size.height += (currLayer.nextNode?.brush.thickness ?? 5) * 4.0;
            
            setNeedsDisplay(boundingBox)
        }
        else {
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            setNeedsDisplay()
        }
        
        self.delegate?.isDrawing(on: self, withTool: currentTool)
    }
    
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing.
        if currLayer.allowsDrawing == false { return }
        
        // Make sure the point is recorded.
        touchesMoved(touches, with: event)
        
        // Finish drawing.
        self.finishDrawingNode()
    }
    
    
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing.
        if currLayer.allowsDrawing == false { return }
        
        // Make sure the point is recorded.
        touchesEnded(touches, with: event)
    }
    
}



