//
//  Helpers.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation


/** Returns the midpoint between two points. */
func midpoint(a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
}

extension Comparable {
    func clamp<T: Comparable>(lower: T, _ upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
}
