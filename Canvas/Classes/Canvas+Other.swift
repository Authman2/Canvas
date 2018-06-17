//
//  Canvas+Other.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/10/18.
//

import Foundation

public extension Canvas {
    
    /** Draws the currently executing drawing path before it gets converted to svg. */
    internal func drawTemporaryPen() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let node = nextNode else { return }
        
        context.addPath(node.mutablePath)
        context.setLineCap(currentBrush.shape)
        context.setLineJoin(currentBrush.joinStyle)
        context.setLineWidth(currentBrush.thickness)
        context.setStrokeColor(currentBrush.color.cgColor)
        context.setBlendMode(.normal)
        context.setMiterLimit(currentBrush.miter)
        context.setAlpha(currentBrush.opacity)
        context.strokePath()
    }
    
    /** Draws the currently executing drawing path before it gets converted to svg. */
    func drawTemporaryEraser() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let node = nextNode else { return }
        
        context.addPath(node.mutablePath)
        context.setLineCap(currentBrush.shape)
        context.setLineJoin(currentBrush.joinStyle)
        context.setLineWidth(currentBrush.thickness)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setBlendMode(.normal)
        context.setMiterLimit(currentBrush.miter)
        context.setAlpha(currentBrush.opacity)
        context.strokePath()
    }
    
    /** Draws the currently executing drawing path before it gets converted to svg. */
    func drawTemporaryLine() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard var node = nextNode else { return }
        
        context.setLineCap(currentBrush.shape)
        context.setLineJoin(currentBrush.joinStyle)
        context.setLineWidth(currentBrush.thickness)
        context.setStrokeColor(currentBrush.color.cgColor)
        context.setMiterLimit(currentBrush.miter)
        context.setAlpha(currentBrush.opacity)
        
        node.lastPoint = currentPoint
        context.move(to: node.firstPoint)
        context.addLine(to: node.lastPoint)
        
        context.strokePath()
    }
    
    /** Draws the currently executing drawing path before it gets converted to svg. */
    func drawTemporaryRectangle() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard var node = nextNode else { return }
        
        context.setLineCap(currentBrush.shape)
        context.setLineJoin(currentBrush.joinStyle)
        context.setLineWidth(currentBrush.thickness)
        context.setMiterLimit(currentBrush.miter)
        context.setAlpha(currentBrush.opacity)
        
        // Stoke the outline of the shape.
        node.lastPoint = currentPoint
        node.setBoundingBox()
        context.setStrokeColor(currentBrush.color.cgColor)
        context.stroke(node.boundingBox)
        
        // If the shape has a fill color, color in the fill inside of the border.
//        if let fill = node.fillColor {
//            context.setFillColor(fill)
//            context.fill(node.innerRect ?? node.boundingBox.insetBy(dx: currentBrush.thickness, dy: currentBrush.thickness))
//        }
    }
    
    /** Draws the currently executing drawing path before it gets converted to svg. */
    func drawTemporaryEllipse() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard var node = nextNode else { return }
        
        context.setLineCap(currentBrush.shape)
        context.setLineJoin(currentBrush.joinStyle)
        context.setLineWidth(currentBrush.thickness)
        context.setMiterLimit(currentBrush.miter)
        context.setAlpha(currentBrush.opacity)
        
        // Color the border.
        node.lastPoint = currentPoint
        node.setBoundingBox()
        context.setStrokeColor(currentBrush.color.cgColor)
        context.strokeEllipse(in: node.boundingBox)
        
        // If the shape has a fill color, color in the fill inside of the border.
//        if let fill = node.fillColor {
//            context.setFillColor(fill)
//            context.fillEllipse(in: node.innerRect ?? node.boundingBox.insetBy(dx: currentBrush.thickness, dy: currentBrush.thickness))
//        }
    }
    
    
    /** Draws the currently executing drawing path before it gets converted to svg. */
    func drawTemporarySelection() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard var node = nextNode else { return }
        
        context.setLineCap(.square)
        context.setLineJoin(.miter)
        context.setLineWidth(1)
        context.setMiterLimit(1)
        context.setFlatness(1)
        context.setAlpha(1)
        context.setLineDash(phase: 0, lengths: [10, 10])
        
        // Stoke the outline of the shape.
        node.lastPoint = currentPoint
        node.setBoundingBox()
        context.setStrokeColor(currentBrush.color.cgColor)
        context.stroke(node.boundingBox)
    }
    
    
}
