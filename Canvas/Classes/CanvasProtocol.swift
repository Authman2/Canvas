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
    
}




