//
//  UIColor+RGB.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/19/18.
//

import Foundation


public extension UIColor {
    
    /** Returns the RGBA values of a color, or (0,0,0,0) if the color could not be extracted. */
    public var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let comps = cgColor.components else { return (red: 255, green: 255, blue: 255, alpha: 1) }
        
        switch comps.count {
        case 0: return (red: 1, green: 1, blue: 1, alpha: 1)
        case 1: return (red: comps[0], green: 1, blue: 1, alpha: 1)
        case 2: return (red: comps[0], green: comps[1], blue: 1, alpha: 1)
        case 3: return (red: comps[0], green: comps[1], blue: comps[2], alpha: 1)
        case 4: return (red: comps[0], green: comps[1], blue: comps[2], alpha: comps[3])
        default: return (red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    
}
