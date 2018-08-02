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
        guard var node = nextNode else { return }
        node.lastPoint = currentPoint
        
        // Finish with a certain tool.
        switch currentDrawingTool {
        case .pen:
            node.mutablePath.closeSubpath()
            break
        case .line:
            node.mutablePath.move(to: node.firstPoint)
            node.mutablePath.addLine(to: node.lastPoint)
            break
        case .rectangle:
            let w = node.lastPoint.x - node.firstPoint.x
            let h = node.lastPoint.y - node.firstPoint.y
            let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
            node.mutablePath.move(to: node.firstPoint)
            node.mutablePath.addRect(rect)
            break
        case .ellipse:
            let w = node.lastPoint.x - node.firstPoint.x
            let h = node.lastPoint.y - node.firstPoint.y
            let rect = CGRect(x: node.firstPoint.x, y: node.firstPoint.y, width: w, height: h)
            node.mutablePath.move(to: node.firstPoint)
            node.mutablePath.addEllipse(in: rect)
            break
        default:
            break
        }
        
        // Update the drawing.
        currLayer.makeNewShapeLayer(node: &node)
        
        // Undo/redo
        let cL = self.currentCanvasLayer

        undoRedoManager.add(undo: {
            var la = self.layers[cL].drawingArray ?? []
            if la.count > 0 { la.removeLast() }
            return (la, cL)
        }) {
            var la = self.layers[cL].drawingArray
            la?.append(node)
            return (la, cL)
        }
        undoRedoManager.clearRedos()

        self.delegate?.didEndDrawing(on: self, withTool: currentDrawingTool)
        nextNode = nil
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
        nextNode = Node(type: currentTool.rawValue)
        
        // Work with each tool.
        switch currentDrawingTool {
        case .pen, .line, .rectangle, .ellipse:
            nextNode?.setInitialPoint(point: currentPoint)
            delegate?.didBeginDrawing(on: self, withTool: currentDrawingTool)
        case .selection:
            nextNode?.setInitialPoint(point: currentPoint)
            
            // Initial click of selection.
            if currLayer.transformBox.contains(currentPoint) { currLayer.isDragging = true }
            else { currLayer.isDragging = false }
            break
        case .eyedropper:
            break
        default:
            break
        }
    }
    
    
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let currLayer = currentLayer else { return }
        guard var next = nextNode else { return }
        
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
        
        // Is nodes are selected, drag them.
        if !currLayer.selectedNodes.isEmpty && currLayer.isDragging {
            for node in currLayer.selectedNodes {
                if !node.isMovable { continue }
                
                var pos = node.shapeLayer.position
                pos.x += touch.deltaX
                pos.y += touch.deltaY
                node.shapeLayer.position = pos
                
                currLayer.calculateTransformBox()
                setNeedsDisplay()
            }
            self.delegate?.didMoveNodes(on: self, movedNodes: currLayer.selectedNodes)
        }
        
        // Draw based on the current tool.
        switch currentDrawingTool {
        case .eyedropper:
            return
        case .pen:
            var boundingBox = next.addPath(p1: lastLastPoint, p2: lastPoint, currentPoint: currentPoint, tool: currentDrawingTool)
            boundingBox.origin.x -= currentBrush.thickness * 2.0;
            boundingBox.origin.y -= currentBrush.thickness * 2.0;
            boundingBox.size.width += currentBrush.thickness * 4.0;
            boundingBox.size.height += currentBrush.thickness * 4.0;
            
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            setNeedsDisplay(boundingBox)
            break
        case .eraser:
            let erasePoint = currentPoint
            
            for i in 0..<currLayer.drawingArray.count {
                var node = currLayer.drawingArray[i]
                
                switch node.nodeType {
                case 0:
                    // PEN:
                    // Get the points and instructions that are currently there.
                    let instructions = node.mutablePath.bezierPointsAndTypes
                    
                    // Get the items that do not have a point in the range of the erase point.
                    let erasedInstructions = instructions.filter { item in
                        let contains = item.0.contains { (cgPoint: CGPoint) -> Bool in
                            return cgPoint.inRange(of: erasePoint, by: 5)
                        }
                        
                        if contains {
                            return false
                        } else {
                            return true
                        }
                    }
                    
                    // Create a new path without the erased sections.
                    let nPath = buildPath(from: erasedInstructions.map { $0.1 }, bPoints: erasedInstructions.map { $0.0 })
                    node.mutablePath = nPath
                    node.shapeLayer.path = node.mutablePath
                    currLayer.drawingArray[i] = node
                    break
                case 2:
                    // LINE:
                    currLayer.drawingArray.remove(at: i)
                    break
                case 3:
                    // RECTANGLE:
                    currLayer.drawingArray.remove(at: i)
                    break
                case 4:
                    // ELLIPSE:
                    currLayer.drawingArray.remove(at: i)
                    break
                default:
                    break
                }
                
                setNeedsDisplay()
            }
            break
        case .line:
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            setNeedsDisplay()
            break
        case .rectangle, .selection:
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            next.setBoundingBox()
            setNeedsDisplay()
            break
        case .ellipse:
            next.move(from: lastPoint, to: currentPoint, tool: currentDrawingTool)
            next.setBoundingBox()
            setNeedsDisplay()
            break
        default:
            break
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
        switch currentDrawingTool {
        case .selection:
            nextNode?.lastPoint = currentPoint
            nextNode!.setBoundingBox()
            var x: CGFloat = 0
            var y: CGFloat = 0
            var w: CGFloat = 0
            var h: CGFloat = 0
            var selectionBox: CGRect
            
            // Get the bounding box of the selection.
            switch nextNode!.lastPoint.location(relative: nextNode!.firstPoint) {
            case .behindX:
                x = nextNode!.lastPoint.x
                y = nextNode!.lastPoint.y
                w = nextNode!.firstPoint.x - x
                h = nextNode!.firstPoint.y - y
                selectionBox = CGRect(x: x, y: y, width: w, height: h)
                break
            case .behindY:
                x = nextNode!.lastPoint.x
                y = nextNode!.lastPoint.y
                w = nextNode!.firstPoint.x - x
                h = nextNode!.firstPoint.y - y
                selectionBox = CGRect(x: x, y: y, width: w, height: h)
                break
            case .behindBoth:
                x = nextNode!.lastPoint.x
                y = nextNode!.lastPoint.y
                w = nextNode!.firstPoint.x - x
                h = nextNode!.firstPoint.y - y
                selectionBox = CGRect(x: x, y: y, width: w, height: h)
                break
            case .inFront:
                selectionBox = nextNode!.boundingBox
                break
            }
            
            // Get the nodes inside the rectangle.
            currLayer.selectedNodes = []
            for node in currLayer.drawingArray {
                if selectionBox.intersects(node.shapeLayer.frame) || selectionBox.contains(node.shapeLayer.frame) {
                    currLayer.selectedNodes.append(node)
                }
            }
            currLayer.calculateTransformBox()
            delegate?.didSelectNodes(on: self, selectedNodes: currLayer.selectedNodes)
            
            // Clear the rect.
            nextNode = nil
            setNeedsDisplay()
            break
        case .eyedropper:
            handleEyedrop(point: currentPoint)
            break
        default:
            touchesMoved(touches, with: event)
            self.finishDrawingNode()
            break
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



