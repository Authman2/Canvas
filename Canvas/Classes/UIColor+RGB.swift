//
//  UIColor+RGB.swift
//  Canvas
//
//  Created by Adeola Uthman on 2/19/18.
//

import Foundation


func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
    var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    
    color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    
    // add the components, but don't let them go above 1.0
    return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
}

func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
    var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
}

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
    
    static func +(color1: UIColor, color2: UIColor) -> UIColor {
        return addColor(color1, with: color2)
    }
    
    static func *(color: UIColor, multiplier: Double) -> UIColor {
        return multiplyColor(color, by: CGFloat(multiplier))
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
