//
//  CGPoint+Range.swift
//  Canvas
//
//  Created by Adeola Uthman on 7/28/18.
//

import Foundation

public extension CGPoint {
    
    /** Returns whether or not this point is within the range of another point. */
    public func inRange(of: CGPoint, by range: CGFloat) -> Bool {
        let dist = self.distance(to: of)
        return dist <= range
    }
    
    
}
