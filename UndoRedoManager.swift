//
//  UndoRedoManager.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/11/18.
//

import Foundation

/** Handles when the user wants to undo and redo lines. */
struct UndoRedoManager {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    var undoStack: Stack<(CGMutablePath, Brush)> = Stack<(CGMutablePath, Brush)>()
    var redoStack: Stack<(CGMutablePath, Brush)> = Stack<(CGMutablePath, Brush)>()
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    mutating func _undo(drawing: inout Bool, view: UIView) {
        if !undoStack.isEmpty {
            drawing = false
            redoStack.push(undoStack.pop()!)
            view.setNeedsDisplay()
        }
    }
    
    mutating func _redo(drawing: inout Bool, view: UIView) {
        if !redoStack.isEmpty {
            drawing = false
            undoStack.push(redoStack.pop()!)
            view.setNeedsDisplay()
        }
    }
    
    
    
    
}

