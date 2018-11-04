//
//  CGPoint+RelativeLocation.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/31/18.
//

import Foundation

public extension CGPoint {
    
    /** Returns the relative location of point a in comparison to point b. */
    public func location(inRelationTo b: CGPoint) -> RelativePointPosition {
        var rpl: RelativePointPosition = .upperRight
        let a: CGPoint = self
        
        if a.x >= b.x && a.y >= b.y {
            rpl = .lowerRight
        } else if a.x < b.x && a.y >= b.y {
            rpl = .lowerLeft
        } else if a.x >= b.x && a.y < b.y {
            rpl = .upperRight
        } else if a.x < b.x && a.y < b.y {
            rpl = .upperLeft
        }
        
        return rpl
    }
    
    
    func distance(to: CGPoint) -> CGFloat {
        let xComp = (to.x - x) ** 2
        let yComp = (to.y - y) ** 2
        return sqrt(xComp + yComp)
    }
    
    
    /** Returns whether or not this point is within the range of another point. */
    public func inRange(of: CGPoint, by range: CGFloat) -> Bool {
        let dist = self.distance(to: of)
        return dist <= range
    }
    
}
