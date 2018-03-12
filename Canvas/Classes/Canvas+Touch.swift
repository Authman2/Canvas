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
        guard let currLayer = currentLayer else { return }
        
        // Update the drawing.
        self.updateDrawing(redraw: false)
        
        // Undo/redo
        undoRedoManager.addUndo(a: (currLayer.nextNode!, currentCanvasLayer, currLayer.nextNode!.id, nil))
        undoRedoManager.clearRedo()

        self.delegate?.didEndDrawing(on: self, withTool: currentDrawingTool)
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
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch?() == true { return }
        
        // Don't continue if there is more than one touch.
        if touches.count > 1 { return }
        
        // Get the first touch point.
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Init (or reinit) the bezier curve. Makes sure the current tool always draws something.
        currLayer.nextNode = createNodeWithCurrentBrush()
        
        // Selection tool vs other tools.
        if currentTool == .selection {
            currLayer.onTouch(touch: touch)
        } else {
            // Add the drawing stroke.
            currLayer.nodeArray.append(currLayer.nextNode!)
        
            // Set initial point.
            currLayer.nextNode!.setInitialPoint(point: currentPoint)
        
            // Call delegate.
            delegate?.didBeginDrawing(on: self, withTool: currentDrawingTool)
        }
    }
    
    
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch?() == true  { return }
        
        // Don't continue if there is more than one touch.
        if touches.count > 1 { return }
        
        // Collect touches.
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Selection tool vs other tools.
        if currentDrawingTool == .selection {
            currLayer.onMove(touch: touch)
            self.delegate?.isDrawing(on: self, withTool: currentDrawingTool)
            return
        }
        
        // Draw based on the current tool.
        switch(currentDrawingTool) {
        case .pen, .eraser:
            var boundingBox = currLayer.nextNode?.addPathLastLastPoint(p1: lastLastPoint, p2: lastPoint, currentPoint: currentPoint) ?? CGRect()
            boundingBox.origin.x -= (currLayer.nextNode?.brush.thickness ?? 5) * 2.0;
            boundingBox.origin.y -= (currLayer.nextNode?.brush.thickness ?? 5) * 2.0;
            boundingBox.size.width += (currLayer.nextNode?.brush.thickness ?? 5) * 4.0;
            boundingBox.size.height += (currLayer.nextNode?.brush.thickness ?? 5) * 4.0;
            
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            currLayer.nextNode?.addPoint(point: currentPoint)
            setNeedsDisplay(boundingBox)
            break
        case .line:
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            currLayer.nextNode?.addPoint(point: currentPoint)
            setNeedsDisplay()
            break
        case .rectangle:
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            currLayer.nextNode?.setBoundingBox()
            setNeedsDisplay()
            break
        case .rectangleFill:
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            currLayer.nextNode?.setBoundingBox()
            setNeedsDisplay()
            break
        case .ellipse:
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            currLayer.nextNode?.setBoundingBox()
            setNeedsDisplay()
            break
        case .ellipseFill:
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            currLayer.nextNode?.setBoundingBox()
            setNeedsDisplay()
            break
        default: break
        }
        
        self.delegate?.isDrawing(on: self, withTool: currentDrawingTool)
    }
    
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch?() == true  { return }
        
        // Don't continue if there is more than one touch.
        if touches.count > 1 { return }
        
        // Make sure the point is recorded.
        touchesMoved(touches, with: event)
        
        // Finish drawing.
        self.finishDrawingNode()
    }
    
    
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch?() == true  { return }
        
        // Don't continue if there is more than one touch.
        if touches.count > 1 { return }
        
        // Make sure the point is recorded.
        touchesEnded(touches, with: event)
    }
    
}



