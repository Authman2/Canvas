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
            case .paint:
                var painted: [Node] = []
                for node in currLayer.drawings {
                    // Base case: the line tool.
                    if node.type == .line {
                        node.strokeColor = self._currentBrush.color
                        painted.append(node)
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
                                node.strokeColor = self._currentBrush.color
                                exit = true
                                break
                            }
                        }
                        if exit == true {
                            painted.append(node)
                            continue
                        }
                        node.fillColor = self._currentBrush.color
                        painted.append(node)
                    }
                }
                self.delegate?.didPaintNodes(on: self, nodes: painted, color: self.currentBrush.color)
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
        
        // 1.) Set up the touch points.
        currentPoint = touch.location(in: self)
        lastPoint = touch.location(in: self)
        lastLastPoint = touch.location(in: self)
        eraserStartPoint = touch.location(in: self)
        
        // 2.) Create a new node that will be placed on the canvas.
        if _currentTool != .eyedropper && _currentTool != .eraser && _currentTool != .paint {
            nextNode = Node(type: self._currentTool)
            nextNode?.strokeColor = self._currentBrush.color
            nextNode?.points.append([currentPoint])
            nextNode?.instructions.append(CGPathElementType.moveToPoint)
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
        
        // 1.) Update the touch points.
        currentPoint = touch.location(in: self)
        lastLastPoint = lastPoint
        lastPoint = touch.previousLocation(in: self)
        
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
                        if i < touchingNodes[key as? Int ?? 0].points.count {
                            touchingNodes[key as? Int ?? 0].points.remove(at: i)
                            touchingNodes[key as? Int ?? 0].instructions.remove(at: i)
                        }
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
