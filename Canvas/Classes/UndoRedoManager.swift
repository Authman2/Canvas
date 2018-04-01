//
//  UndoRedoManager.swift
//  Canvas
//
//  Created by Adeola Uthman on 3/11/18.
//

import Foundation


/** An event for the undo redo manager. */
typealias CanvasEvent = (() -> Void, () -> Void)

/** The manager that handles undoing and redoing actions while working with the canvas. The generic used here represents what should count toward the undo/redo stack. This way, users can define exactly what actions in their app should trigger undos and redos. */
public class UndoRedoManger {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    private var undoIndex: Int
    private var stack: [CanvasEvent]
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    init() {
        stack = []
        undoIndex = 0
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Adds a new action to undos. */
    public func add(undo: @escaping () -> Void, redo: @escaping () -> Void) {
        stack.append(CanvasEvent(undo, redo))
        undoIndex = stack.count - 1
    }
    
    /** Undo the last event. */
    public func performUndo() {
        if undoIndex < 0 || undoIndex >= stack.count { return }
        if stack.count == 0 { return }
        
        let last = stack[undoIndex].0
        last()
        undoIndex -= 1
    }
    
    /** Redo the last event. */
    public func performRedo() {
        if undoIndex < -1 || undoIndex + 1 >= stack.count { return }
        if stack.count == 0 { return }
        
        let last = stack[undoIndex + 1].1
        last()
        if undoIndex + 1 < stack.count { undoIndex += 1 }
    }
    
    /** Clears the redos. */
    public func clearRedos() {
        for i in undoIndex+1..<stack.count {
            stack[i].1 = {
                print("redone")
            }
        }
    }
    
    
    
}
