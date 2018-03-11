//
//  UndoRedoManager.swift
//  Canvas
//
//  Created by Adeola Uthman on 3/11/18.
//

import Foundation

/** The manager that handles undoing and redoing actions while working with the canvas. The generic used here represents what should count toward the undo/redo stack. This way, users can define exactly what actions in their app should trigger undos and redos. */
class UndoRedoManger<T> {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The arrays of the undos and the redos. */
    private var undos: [(Node?, Int?, Int?, (T, T)?)]!
    private var redos: [(Node?, Int?, Int?, (T, T)?)]!
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    init() {
        undos = []
        redos = []
    }
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    /** Adds to the undo stack. */
    func addUndo(a: (Node?, Int?, Int?, (T, T)?)) {
        undos.append(a)
    }
    
    
    /** Returns the most recent object in the undo stack. In other words, the previous state of the undo redo manager. */
    func lastUndo() -> (Node?, Int?, Int?, (T, T)?)? {
        guard let last = undos.popLast() else { return nil }
        redos.append(last)
        return last
    }
    
    
    /** Returns the most recent object in the redo stack. In other words, the previous state of the undo redo manager. */
    func lastRedo() -> (Node?, Int?, Int?, (T, T)?)? {
        guard let last = redos.popLast() else { return nil }
        undos.append(last)
        return last
    }
    
    
    /** Clears the undo stack. */
    func clearUndo() { undos = [] }
    
    /** Clears the redo stack. */
    func clearRedo() { redos = [] }
    
}
