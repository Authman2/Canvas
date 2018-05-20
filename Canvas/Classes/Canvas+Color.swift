//
//  Canvas+Color.swift
//  Canvas
//
//  Created by Adeola Uthman on 5/19/18.
//

import Foundation

extension Canvas {
    
    /** Sets the fill color on the selected node. */
    public func fillSelectedNodes(with color: UIColor) {
        guard let cLay = currentLayer else { return }
        var lastNodes: [Node] = []
        var lastColors: [UIColor?] = []
        
        for node in cLay.selectedNodes {
            lastNodes.append(node)
            if node.shapeLayer.fillColor == nil {
                lastColors.append(nil)
            } else {
                lastColors.append(UIColor(cgColor: node.shapeLayer.fillColor ?? UIColor.black.cgColor))
            }
            node.shapeLayer.fillColor = color.cgColor
        }
        
        undoRedoManager.add(undo: {
            for i in 0..<lastNodes.count {
                lastNodes[i].shapeLayer.fillColor = lastColors[i]?.cgColor
            }
            self.setNeedsDisplay()
            return nil
        }, redo: {
            for i in 0..<lastNodes.count {
                lastNodes[i].shapeLayer.fillColor = color.cgColor
            }
            self.setNeedsDisplay()
            return nil
        })
        undoRedoManager.clearRedos()
        
        delegate?.didChangeFill(on: self, filledNodes: cLay.selectedNodes, fillColor: color)
    }
    
    
    /** Sets the stroke color on the selected node. */
    public func strokeSelectedNodes(with color: UIColor) {
        guard let cLay = currentLayer else { return }
        var lastNodes: [Node] = cLay.selectedNodes
        var lastColors: [UIColor?] = []
        
        for node in cLay.selectedNodes {
            if node.shapeLayer.strokeColor == nil { lastColors.append(nil) }
            else { lastColors.append(UIColor(cgColor: node.shapeLayer.strokeColor ?? UIColor.black.cgColor)) }
            
            node.shapeLayer.strokeColor = color.cgColor
        }
        
        // Undo/Redo
        undoRedoManager.add(undo: {
            for i in 0..<lastNodes.count {
                lastNodes[i].shapeLayer.strokeColor = lastColors[i]?.cgColor
            }
            self.setNeedsDisplay()
            return nil
        }, redo: {
            for i in 0..<lastNodes.count {
                lastNodes[i].shapeLayer.strokeColor = color.cgColor
            }
            self.setNeedsDisplay()
            return nil
        })
        undoRedoManager.clearRedos()
        
        delegate?.didChangeStroke(on: self, paintedNodes: cLay.selectedNodes, strokeColor: color)
    }
    
    
    /** Handles grabbing a color from an area on the canvas. */
    func handleEyedrop(point: CGPoint) {
        // Only track the eyedropper on the canvas.
        if hitTest(point, with: nil) != self { return }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixels: [UInt8] = [0,0,0,0]
        
        if let context = CGContext(data: &pixels, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmap.rawValue) {
            
            context.translateBy(x: -point.x, y: -point.y)
            self.layer.render(in: context)
            
            let r = CGFloat(pixels[0])/CGFloat(255)
            let g = CGFloat(pixels[1])/CGFloat(255)
            let b = CGFloat(pixels[2])/CGFloat(255)
            let a = CGFloat(pixels[3])/CGFloat(255)
            
            let color = UIColor(red: r, green: g, blue: b, alpha: a)
            var nBrush = self.currentBrush
            nBrush.color = color
            self.setBrush(brush: nBrush)
            self.delegate?.didSampleColor(on: self, color: color)
        }
    }
    
    
    
    
    
    
    
}
