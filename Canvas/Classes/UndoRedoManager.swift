//
//  UndoRedoManager.swift
//  Canvas
//
//  Created by Adeola Uthman on 11/3/18.
//

import Foundation

/** The manager that handles undoing and redoing actions while working with the canvas. The generic used here represents what should count toward the undo/redo stack. This way, users can define exactly what actions in their app should trigger undos and redos. */
public class UndoRedoManager {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The undo redo stack, which is an array of dictionaries of the format [undo/redo : function] */
    var stack: [[Int : () -> Any?]]
    
    /** The separate redo stack to keep track of what can and should be redone next. */
    var redos: [[Int : () -> Any?]]
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    init() {
        stack = []
        redos = []
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Adds a new action to undos. */
    public func add(undo: @escaping () -> Any?, redo: @escaping () -> Any?) {
        // Add two entries to the dictionary, an undo and a redo with the respective indexes.
        stack.append([0: undo, 1: redo])
    }
    
    /** Undo the last event. */
    public func performUndo() -> Any? {
        if stack.isEmpty == true { return nil }
        
        // Get the last item in the stack.
        guard let last = stack.popLast() else { return nil }
        
        // That last item is a function that says how something should be undone. Run the function.
        let val = last[0]?()
        
        // Now take the redo of that function and add it to the redo stack.
        redos.insert(last, at: 0)
        
        return val
    }
    
    /** Redo the last event. */
    public func performRedo() -> Any? {
        if redos.isEmpty == true { return nil }
        
        // Get the last item in the redos.
        let last = redos.removeFirst()
        
        // Run that function to perform the redo.
        let val = last[1]?()
        
        // Make sure you add back the redo to the undo stack.
        stack.append(last)
        
        return val
    }
    
    /** Clears the redos. */
    public func clearRedos() {
        redos.removeAll()
    }
    
    
    
}
