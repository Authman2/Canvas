//
//  Canvas+Touch.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

extension Canvas {
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    private func finishDrawing() {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        
        
        if let next = nextNode {
            currLayer.drawings.append(next)
        } else {

            // Some tools do not produce nodes, so handle their actions differently here.
            switch _currentTool {
            case .eyedropper:
                handleEyedrop(point: currentPoint)
                break
            default:
                break
            }
            
        }
        nextNode = nil
        setNeedsDisplay()
        
        // Call delegate method.
        self.delegate?.didFinishDrawing(on: self)
        
        print("Only node: \(currLayer.drawings[0].points)")
    }
    
    
    
    
    
    
    /************************
     *                      *
     *        TOUCHES       *
     *                      *
     ************************/
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        guard let touch = touches.first else { return }
        guard let allTouches = event?.allTouches else { return }
        if allTouches.count > 1 { return }
        
        // 1.) Set up the touch points.
        currentPoint = touch.location(in: self)
        lastPoint = touch.location(in: self)
        lastLastPoint = touch.location(in: self)
        
        // 2.) Create a new node that will be placed on the canvas.
        if _currentTool != .eyedropper {
            nextNode = Node(type: self._currentTool)
            nextNode?.points.append([currentPoint])
            nextNode?.instructions.append(CGPathElementType.moveToPoint)
        }
        
        // 3.) Call delegate method.
        self.delegate?.willBeginDrawing(on: self)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        guard let next = nextNode else { return }
        guard let touch = touches.first else { return }
        guard let allTouches = event?.allTouches else { return }
        if allTouches.count > 1 { return }
        
        // 1.) Update the touch points.
        currentPoint = touch.location(in: self)
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        
        // 2.) Depending on the tool, add points and instructions for drawing.
        switch _currentTool {
        case .pen:
            next.points.append([currentPoint, lastPoint, lastLastPoint])
            next.instructions.append(CGPathElementType.addQuadCurveToPoint)
            break
        case .eraser:
            // Start from the first erase point.
            // Map the points of points into just average points
            // Remove the points points at the in-range-average-point
            // Split the node into two nodes: one for 0..erase-start and one from erase-end to node-end.
            break
        case .line:
            let tempFirst = next.points[0][0]
            next.points.removeAll()
            next.instructions.removeAll()
            
            next.points.append([tempFirst])
            next.points.append([currentPoint])
            
            next.instructions.append(CGPathElementType.moveToPoint)
            next.instructions.append(CGPathElementType.addLineToPoint)
            break
        case .rectangle, .ellipse:
            let tempFirst = next.points[0][0]
            next.points.removeAll()
            next.instructions.removeAll()
            
            next.points.append([tempFirst, currentPoint])
            next.instructions.append(CGPathElementType.addLineToPoint)
            break
        default:
            break
        }
        
        // 3.) Update the temporary drawing on screen.
        setNeedsDisplay()
        
        // 4.) Call delegate method.
        self.delegate?.isDrawing(on: self)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        guard let allTouches = event?.allTouches else { return }
        if allTouches.count > 1 { return }
        
        finishDrawing()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        guard let allTouches = event?.allTouches else { return }
        if allTouches.count > 1 { return }
        
        finishDrawing()
    }
    
}
