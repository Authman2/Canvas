//
//  CanvasEvents.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

public protocol CanvasEvents {
    
    /** Called just before you start drawing. */
    func willBeginDrawing(on canvas: Canvas)
    
    
    /** Called every time you move your finger while drawing. */
    func isDrawing(on canvas: Canvas)
    
    
    /** Called when you lift your finger off of the canvas. */
    func didFinishDrawing(on canvas: Canvas)
    
    
    /** Called when a color is sampled using the eyedropper tool. */
    func didSampleColor(on canvas: Canvas, sampledColor color: UIColor)
    
    
    /** Called when you paint one or more nodes. */
    func didPaintNodes(on canvas: Canvas, nodes: [Node], strokeColor: UIColor, fillColor: UIColor?)
    
    
    /** Called when you undo an action. */
    func didUndo(on canvas: Canvas)
    
    
    /** Called when you redo an action. */
    func didRedo(on canvas: Canvas)
    
    
    /** Called when nodse get copied. */
    func didCopyNodes(on canvas: Canvas, nodes: [Node])
    
    
    /** Called when nodes are pasted. */
    func didPasteNodes(on canvas: Canvas, on layer: CanvasLayer, nodes: [Node])
    
}
