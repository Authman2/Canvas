//
//  CanvasProtocol.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/9/18.
//

import Foundation

/** Methods to get called when certain actions are taken on the Canvas view. */
public protocol CanvasDelegate {
    
    /** Called when the user starts drawing on the canvas. */
    func didBeginDrawing(on canvas: Canvas, withTool tool: CanvasTool)
    
    /** Called each time the user moves a finger around the canvas. */
    func isDrawing(on canvas: Canvas, withTool tool: CanvasTool)
    
    /** Called when the user stops drawing on the canvas. */
    func didEndDrawing(on canvas: Canvas, withTool tool: CanvasTool)
    
    /** Called when a node on the canvas is selected using the selection tool. */
    func didSelectNode(on canvas: Canvas, selectedNode: Node)
    
    /** Called when a node is copied. */
    func didCopyNode(on canvas: Canvas, copiedNode: Node?)
    
    /** Called when a node is pasted. */
    func didPasteNode(on canvas: Canvas, pastedNode: Node)
 
    /** Called when the selected node is moved using the selection tool. */
    func didMoveNode(on canvas: Canvas, movedNode: Node?)
    
    /** Called when the paint bucket tool is used. */
    func didPaintNode(on canvas: Canvas, paintedNode: Node)
    
    /** Called when the eyedropper is used to sample a color. */
    func didSampleColor(on canvas: Canvas, color: UIColor)
    
    /** Called whenever an undo occurs. */
    func didUndo(on canvas: Canvas)
    
    /** Called whenever a redo occurs. */
    func didRedo(on canvas: Canvas)
    
}




