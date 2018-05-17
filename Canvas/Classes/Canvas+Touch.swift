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
        guard let node = currLayer.nextNode else { return }
        
        // Finish with a certain tool.
        switch currentDrawingTool {
        case .pen:
            break
        case .line:
            node.path.move(to: node.firstPoint)
            node.path.addLine(to: node.lastPoint)
            break
        case .rectangle:
            let w = node.lastPoint.x - node.firstPoint.x
            let h = node.lastPoint.y - node.firstPoint.y
            let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
            node.path.addRect(rect)
            break
        case .ellipse:
            let w = node.lastPoint.x - node.firstPoint.x
            let h = node.lastPoint.y - node.firstPoint.y
            let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
            node.path.addEllipse(in: rect)
            break
        default:
            break
        }
        
        // Update the drawing.
        currLayer.drawSVG(node: node)
//        currLayer.updateLayer(redraw: false)
        
        // Undo/redo
        let cL = self.currentCanvasLayer
        
        undoRedoManager.add(undo: {
            var la = self.layers[cL].nodeArray ?? []
            if la.count > 0 { la.removeLast() }
            return (la, cL)
        }) {
            var la = self.layers[cL].nodeArray
            la?.append(node)
            return (la, cL)
        }
        undoRedoManager.clearRedos()

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
        if currLayer.allowsDrawing == false || preemptTouch == true { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Get the first touch point.
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Init (or reinit) the bezier curve. Makes sure the current tool always draws something.
        currLayer.nextNode = createNodeWithCurrentBrush()
        
        // Selection tool vs other tools.
        if currentTool == .selection {
            currLayer.onTouch(touch: touch)
        }
        else if currentTool == .eyedropper || currentTool == .paint {
            return
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
        if currLayer.allowsDrawing == false || preemptTouch == true  { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Collect touches.
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        // Calculate the translation of the touch.
        touch.deltaX = currentPoint.x - lastPoint.x
        touch.deltaY = currentPoint.y - lastPoint.y
        
        // Selection tool vs other tools.
        if currentDrawingTool == .selection {
            currLayer.onMove(touch: touch)
            return
        }
        
        // Eyedropper tool.
        if currentDrawingTool == .eyedropper || currentDrawingTool == .paint {
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
            setNeedsDisplay()
            break
        case .rectangle:
            currLayer.nextNode?.move(from: lastPoint, to: currentPoint)
            currLayer.nextNode?.setBoundingBox()
            setNeedsDisplay()
            break
        case .ellipse:
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
        if currLayer.allowsDrawing == false || preemptTouch == true  { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Selection tool vs other tools
        if currentDrawingTool == .selection {
            currLayer.onRelease(point: currentPoint)
        }
        else if currentDrawingTool == .eyedropper {
            handleEyedrop(point: currentPoint)
        }
        else if currentDrawingTool == .paint {
            handlePaintBucket(point: currentPoint)
        } else {
            // Make sure the point is recorded.
            touchesMoved(touches, with: event)
        
            // Finish drawing.
            self.finishDrawingNode()
        }
    }
    
    
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currLayer = currentLayer else { return }
        
        // Don't continue if the layer does not allow drawing or should be preempted.
        if currLayer.allowsDrawing == false || preemptTouch == true  { return }
        
        // Don't continue if there is more than one touch.
        if let evT = event?.touches(for: self) {
            if evT.count > 1 { return }
        }
        
        // Make sure the point is recorded.
        touchesEnded(touches, with: event)
    }
    
}



