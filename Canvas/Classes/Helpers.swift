//
//  Helpers.swift
//  Canvas
//
//  Created by Adeola Uthman on 1/10/18.
//

import Foundation

/** Canvas tools. */
public enum CanvasTool {
    case pen
    case eraser
    case line
    case rectangle
    case ellipse
    case eyedropper
    case paint
    case selection
}


/** Returns the midpoint between two points. */
func midpoint(a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
}

extension Comparable {
    func clamp<T: Comparable>(lower: T, _ upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
}

extension CGPoint {
    func distance(to: CGPoint) -> CGFloat {
        return sqrt(((x ** 2) - (to.x ** 2)) + ((y ** 2) + (to.y ** 2)))
    }
}

/** lhs to the power of rhs. */
infix operator **
func **(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
    return pow(lhs, rhs)
}
func **(lhs: Int, rhs: Int) -> Int {
    return Int(pow(CGFloat(lhs), CGFloat(rhs)))
}
