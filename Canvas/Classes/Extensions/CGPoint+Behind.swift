//
//  CGPoint+Behind.swift
//  Canvas
//
//  Created by Adeola Uthman on 5/18/18.
//

import Foundation

/** Whether a certain point is behind x, behind y, or both. */
enum RelativePointLocation {
    case behindX
    case behindY
    case behindBoth
    case inFront
}

extension CGPoint {
    
    /** Returns where the current point is relative to another. */
    func location(relative: CGPoint) -> RelativePointLocation {
        if x < relative.x && y >= relative.y {
            return .behindX
        }
        if y < relative.y && x >= relative.x {
            return .behindY
        }
        if x < relative.x && y < relative.y {
            return .behindBoth
        }
        return .inFront
    }
    
}
