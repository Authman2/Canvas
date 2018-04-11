//
//  UndoRedoManager.swift
//  Canvas
//
//  Created by Adeola Uthman on 3/11/18.
//

import Foundation


/** An event for the undo redo manager. */
typealias CanvasEvent = (() -> Any?, () -> Any?)

/** The manager that handles undoing and redoing actions while working with the canvas. The generic used here represents what should count toward the undo/redo stack. This way, users can define exactly what actions in their app should trigger undos and redos. */
public class UndoRedoManger {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    internal var undoIndex: Int
//    internal var redoIndex: Int
//    private var stack: [CanvasEvent]
    private var undos: [() -> Any?]
    private var redos: [() -> Any?]
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    init() {
        undos = []
        redos = []
        undoIndex = 0
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Adds a new action to undos. */
    public func add(undo: @escaping () -> Any?, redo: @escaping () -> Any?) {
        undos.append(undo)
        redos.append(redo)
        undoIndex = undos.count - 1
    }
    
    /** Undo the last event. */
    public func performUndo() -> Any? {
        if undos.count <= 0 { return nil }
        if undoIndex < 0 || undoIndex >= undos.count { return nil }
        
        let last = undos[undoIndex]
        undoIndex -= 1
        return last()
    }
    
    /** Redo the last event. */
    public func performRedo() -> Any? {
        if redos.count <= 0 { return nil }
        if undoIndex < 0 || undoIndex + 1 >= redos.count { return nil }
        
        undoIndex += 1
        let last = redos[undoIndex]
        return last()
    }
    
    /** Clears the redos. */
    public func clearRedos(nodes: [Node], index: Int) {
        if undoIndex >= redos.count - 1 { return }
        
        for i in undoIndex+1..<redos.count {
            redos[i] = { return (nodes, index) }
        }
//        redos[undoIndex] = { return (nodes, index) }
    }
    
    
    
}
