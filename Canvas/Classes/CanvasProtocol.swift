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
    func didBeginDrawing(_ canvas: Canvas)
    
    /** Called each time the user moves a finger around the canvas. */
    func isDrawing(_ canvas: Canvas)
    
    /** Called when the user stops drawing on the canvas. */
    func didEndDrawing(_ canvas: Canvas)
    
}



