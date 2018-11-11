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
            
            // Undo/Redo.
            undoRedoManager.add(undo: {
                if currLayer.drawings.count > 0 {
                    currLayer.drawings.removeLast()
                }
                return nil
            }, redo: {
                currLayer.drawings.append(next)
            })
            undoRedoManager.clearRedos()
        } else {

            // Some tools do not produce nodes, so handle their actions differently here.
            switch _currentTool {
            case .eyedropper:
                handleEyedrop(point: currentPoint)
                break
            case .paint:
                var painted: [Node] = []
                for node in currLayer.drawings {
                    // Base case: the line tool.
                    if node.type == .line {
                        let lastColor = node.brush.strokeColor
                        node.brush.strokeColor = self._currentBrush.strokeColor
                        painted.append(node)
                        
                        // Undo/Redo.
                        undoRedoManager.add(undo: {
                            node.brush.strokeColor = lastColor
                        }, redo: {
                            let newColor = self._currentBrush.strokeColor
                            node.brush.strokeColor = newColor
                            return nil
                        })
                        undoRedoManager.clearRedos()
                        continue
                    }
                    
                    let path = build(from: node.points, using: node.instructions, tool: node.type)
                    
                    // Only take the nodes where the touch is within the bounding box.
                    if path.boundingBox.contains(currentPoint) {
                        // Get the average points.
                        let points = node.points.map { (p) -> CGPoint in
                            var sumX: CGFloat = 0
                            var sumY: CGFloat = 0
                            for pt in p {
                                sumX += pt.x
                                sumY += pt.y
                            }
                            return CGPoint(x: sumX / CGFloat(p.count), y: sumY / CGFloat(p.count))
                        }
                        
                        // If the touch is on a point on the line, then color that. Otherwise fill the inside.
                        var exit: Bool = false
                        for pt in points {
                            if pt.inRange(of: currentPoint, by: 5.0) {
                                let lastColor = node.brush.strokeColor
                                node.brush.strokeColor = self._currentBrush.strokeColor
                                
                                // Undo/Redo.
                                undoRedoManager.add(undo: {
                                    node.brush.strokeColor = lastColor
                                }, redo: {
                                    let newColor = self._currentBrush.strokeColor
                                    node.brush.strokeColor = newColor
                                    return nil
                                })
                                undoRedoManager.clearRedos()
                                
                                exit = true
                                break
                            }
                        }
                        if exit == true {
                            painted.append(node)
                            continue
                        }
                        let lastColor = node.brush.fillColor
                        node.brush.fillColor = self._currentBrush.fillColor
                        painted.append(node)
                        
                        // Undo/Redo.
                        undoRedoManager.add(undo: {
                            node.brush.fillColor = lastColor
                        }, redo: {
                            let newColor = self._currentBrush.fillColor
                            node.brush.fillColor = newColor
                            return nil
                        })
                        undoRedoManager.clearRedos()
                    }
                }
                
                self.delegate?.didPaintNodes(on: self, nodes: painted, strokeColor: self.currentBrush.strokeColor, fillColor: self.currentBrush.fillColor)
                break
            default:
                break
            }
            
        }
        nextNode = nil
        setNeedsDisplay()
        
        // Call delegate method.
        self.delegate?.didFinishDrawing(on: self)
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
        if currLayer.allowsDrawing == false { return }
        
        // 1.) Set up the touch points.
        currentPoint = touch.location(in: self)
        lastPoint = touch.location(in: self)
        lastLastPoint = touch.location(in: self)
        eraserStartPoint = touch.location(in: self)
        
        // 2.) Create a new node that will be placed on the canvas.
        if _currentTool != .eyedropper && _currentTool != .eraser && _currentTool != .paint {
            nextNode = Node(type: self._currentTool)
            nextNode?.brush = currentBrush
            nextNode?.points.append([currentPoint])
            nextNode?.instructions.append(CGPathElementType.moveToPoint)
        }
        if _currentTool == .selection && currLayer.selectedNodes.count > 0 {
            var atLeastOne: Bool = false
            for node in currLayer.selectedNodes {
                let path = build(from: node.points, using: node.instructions, tool: node.type)
                if path.boundingBox.contains(currentPoint) {
                    atLeastOne = true
                    break
                }
            }
            if atLeastOne == false {
                currLayer.selectedNodes.removeAll()
                nextNode = nil
                setNeedsDisplay()
            }
        }
        
        // 3.) Call delegate method.
        self.delegate?.willBeginDrawing(on: self)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        guard let touch = touches.first else { return }
        guard let allTouches = event?.allTouches else { return }
        if allTouches.count > 1 { return }
        if currLayer.allowsDrawing == false { return }
        
        // 1.) Update the touch points.
        currentPoint = touch.location(in: self)
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        
        // 1.5) Calculate the translation of the touch.
        touch.deltaX = currentPoint.x - lastPoint.x
        touch.deltaY = currentPoint.y - lastPoint.y
        
        // 2.) Depending on the tool, add points and instructions for drawing.
        switch _currentTool {
        case .pen:
            guard let next = nextNode else { return }
            next.points.append([currentPoint, lastPoint, lastLastPoint])
            next.instructions.append(CGPathElementType.addQuadCurveToPoint)
            break
        case .eraser:
            // 1.) Find all of the nodes where the touch is within its bounding box. This
            //     will cut the number of nodes to look through down to 1 in the best case or "n" in the worst case.
            // 2.) For every touched node, map its points into an average of its points. This should still be the same
            //     size array as before. Then, as you loop through each point, store its averages in an array at index i.
            // 3.) Loop through each set of average points for each node. If you come across one that is within range of
            //     the touch, save that index i and remove it from the original nodes points points array.
            // 4.) Then split that node into two nodes. The first one will contain all the points and instructions from
            //     0...i with the last instruction being changed to closeSubpath. The second node will be from i...end
            //     and the first instruction will be changed to moveToPoint.
            
            // 1.
            var touchingNodes: [Node] = []
            for node in currLayer.drawings {
                let path = build(from: node.points, using: node.instructions, tool: node.type)
                if path.boundingBox.contains(currentPoint) {
                    touchingNodes.append(node)
                }
            }
            
            // 2.
            let averages: NSMutableDictionary = NSMutableDictionary()
            for i in 0..<touchingNodes.count {
                let node = touchingNodes[i]
                let averaged = node.points.map { (p: [CGPoint]) -> CGPoint in
                    if p.count == 3 {
                        return CGPoint(x: (p[0].x + p[1].x + p[2].x)/3, y: (p[0].y + p[1].y + p[2].y)/3)
                    } else if p.count == 2 {
                        return CGPoint(x: (p[0].x + p[1].x)/2, y: (p[0].y + p[1].y)/2)
                    } else if p.count == 1 {
                        return CGPoint(x: p[0].x, y: p[0].y)
                    } else {
                        return CGPoint()
                    }
                }
                averages.setValue(averaged, forKey: "\(i)")
            }
            
            // 3.
            for (key, val) in averages {
                let averagesForNode = val as? [CGPoint] ?? []
                
                for i in 0..<averagesForNode.count {
                    let point = averagesForNode[i]
                    
                    if point.inRange(of: currentPoint, by: 5.0) {
                        if i < 0 || i >= touchingNodes[key as? Int ?? 0].points.count { continue }
                        
                        let savedP = touchingNodes[key as? Int ?? 0].points[i]
                        let savedI = touchingNodes[key as? Int ?? 0].instructions[i]
                        
                        touchingNodes[key as? Int ?? 0].points.remove(at: i)
                        touchingNodes[key as? Int ?? 0].instructions.remove(at: i)
                        
                        // Undo/Redo.
                        undoRedoManager.add(undo: {
                            touchingNodes[key as? Int ?? 0].points.insert(savedP, at: i)
                            touchingNodes[key as? Int ?? 0].instructions.insert(savedI, at: i)
                            return nil
                        }, redo: {
                            if touchingNodes[key as? Int ?? 0].points.count > i {
                                touchingNodes[key as? Int ?? 0].points.remove(at: i)
                            }
                            if touchingNodes[key as? Int ?? 0].instructions.count > i {
                                touchingNodes[key as? Int ?? 0].instructions.remove(at: i)
                            }
                            return nil
                        })
                        undoRedoManager.clearRedos()
                    }
                }
            }
            break
        case .line:
            guard let next = nextNode else { return }
            let tempFirst = next.points[0][0]
            next.points.removeAll()
            next.instructions.removeAll()
            
            next.points.append([tempFirst])
            next.points.append([currentPoint])
            
            next.instructions.append(CGPathElementType.moveToPoint)
            next.instructions.append(CGPathElementType.addLineToPoint)
            break
        case .rectangle, .ellipse:
            guard let next = nextNode else { return }
            let tempFirst = next.points[0][0]
            next.points.removeAll()
            next.instructions.removeAll()
            
            next.points.append([tempFirst, currentPoint])
            next.instructions.append(CGPathElementType.addLineToPoint)
            break
        case .selection:
            if currLayer.selectedNodes.count == 0 {
                guard let next = nextNode else { return }
                let tempFirst = next.points[0][0]
                next.points.removeAll()
                next.instructions.removeAll()
                
                next.points.append([tempFirst, currentPoint])
                next.instructions.append(CGPathElementType.addLineToPoint)
            } else {
                nextNode = nil
                
                var containsAtLeastOne: Bool = false
                for node in currLayer.selectedNodes {
                    // See if the current point is within the node's bounding box.
                    let path = build(from: node.points, using: node.instructions, tool: node.type)
                    if path.boundingBox.contains(currentPoint) {
                        containsAtLeastOne = true
                        break
                    }
                }
                
                // Make sure the touch is within at least one bounding box.
                if containsAtLeastOne == true {
                    for node in currLayer.selectedNodes {
                        // Move the points by the selection translation amount.
                        let nPoints = node.points.map { (points: [CGPoint]) -> [CGPoint] in
                            var nP = points
                            for i in 0..<points.count {
                                nP[i].x += touch.deltaX
                                nP[i].y += touch.deltaY
                            }
                            return nP
                        }
                    
                        // Set the new points.
                        node.points = nPoints
                    }
                    
                    // Delegate.
                    self.delegate?.didMoveNodes(on: self, movedNodes: currLayer.selectedNodes)
                } else {
                    // Reset the selected nodes.
                    currLayer.selectedNodes.removeAll()
                    setNeedsDisplay()
                }
            }
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
        if currLayer.allowsDrawing == false { return }
        
        if _currentTool == .selection {
            if currLayer.selectedNodes.count == 0 {
                guard let next = nextNode else { return }
                let first = next.points[0][0]
                let last = next.points[0][1]
                let w = last.x - first.x
                let h = last.y - first.y
                let dest = CGRect(x: first.x, y: first.y, width: w, height: h)
            
                handleSelection(with: dest)
                setNeedsDisplay()
            }
            nextNode = nil
        } else {
            finishDrawing()
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self._currentCanvasLayer >= self._canvasLayers.count { return }
        let currLayer = self._canvasLayers[self._currentCanvasLayer]
        guard let allTouches = event?.allTouches else { return }
        if allTouches.count > 1 { return }
        if currLayer.allowsDrawing == false { return }
        
        if _currentTool == .selection {
            if currLayer.selectedNodes.count == 0 {
                guard let next = nextNode else { return }
                let first = next.points[0][0]
                let last = next.points[0][1]
                let w = last.x - first.x
                let h = last.y - first.y
                let dest = CGRect(x: first.x, y: first.y, width: w, height: h)
                
                handleSelection(with: dest)
                setNeedsDisplay()
            }
            nextNode = nil
        } else {
            finishDrawing()
        }
    }
    
}
