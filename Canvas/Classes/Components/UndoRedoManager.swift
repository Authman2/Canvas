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
    
    var undoStack: Stack<CGMutablePath> = Stack<CGMutablePath>()
    var redoStack: Stack<CGMutablePath> = Stack<CGMutablePath>()
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/

    mutating func _undo(path: inout CGMutablePath, view: UIView) {
        if !undoStack.isEmpty {
            // First, get the current line so it can be used for redo.
            redoStack.push(path.mutableCopy()!)
            
            // Undo.
            let p = undoStack.pop()!
            path = p
            view.setNeedsDisplay()
        }
    }
    
    mutating func _redo(path: inout CGMutablePath, view: UIView) {
        if !redoStack.isEmpty {
            // First, add back to the undo stack.
            undoStack.push(path.mutableCopy()!)
            
            // Redo.
            let p = redoStack.pop()!
            path = p
            view.setNeedsDisplay()
        }
    }
    
    
    
    
}
