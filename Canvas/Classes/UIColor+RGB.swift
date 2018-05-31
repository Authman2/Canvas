//
//  UIColor+RGB.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/19/18.
//

import Foundation


public extension UIColor {
    
    /** Returns the RGBA values of a color, or (0,0,0,0) if the color could not be extracted. */
    public var rgba: [CGFloat] {
        guard let comps = cgColor.components else { return [0, 0, 0, 0] }
        
        switch comps.count {
        case 0: return [1, 1, 1, 1]
        case 1: return [comps[0], 1, 1, 1]
        case 2: return [comps[0], comps[1], 1, 1]
        case 3: return [comps[0], comps[1], comps[2], 1]
        case 4: return [comps[0], comps[1], comps[2], comps[3]]
        default: return [1,1,1, 1]
        }
    }
    
}

public extension CGColor {
    
    /** Returns the RGBA values of a color, or (0,0,0,0) if the color could not be extracted. */
    public var rgba: [CGFloat] {
        guard let comps = components else { return [0, 0, 0, 0] }
        
        switch comps.count {
        case 0: return [1, 1, 1, 1]
        case 1: return [comps[0], 1, 1, 1]
        case 2: return [comps[0], comps[1], 1, 1]
        case 3: return [comps[0], comps[1], comps[2], 1]
        case 4: return [comps[0], comps[1], comps[2], comps[3]]
        default: return [1,1,1, 1]
        }
    }
    
}
