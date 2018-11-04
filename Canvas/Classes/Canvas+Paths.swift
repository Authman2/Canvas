//
//  Canvas+Paths.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/8/18.
//

import Foundation

/** Builds and returns a CGMutablePath from a set of points and instructions. */
public func build(from points: [[CGPoint]], using instructions: [CGPathElementType], tool: CanvasTool) -> CGMutablePath {
    let mutablePath = CGMutablePath()
    mutablePath.move(to: points[0][0])
    
    // Handle rectangles and ellipses.
    if tool == .rectangle || tool == .ellipse {
        let first = points[0][0]
        let last = points[0][1]
        let w = last.x - first.x
        let h = last.y - first.y
        let dest = CGRect(x: first.x, y: first.y, width: w, height: h)
        
        if tool == .rectangle || tool == .selection {
            mutablePath.addRect(dest)
        } else if tool == .ellipse {
            mutablePath.addEllipse(in: dest)
        }
        return mutablePath
    }
    
    for i in 0..<instructions.count {
        switch instructions[i] {
        case .moveToPoint:
            if tool != .pen {
                mutablePath.move(to: points[i][0])
            }
            break
        case .addLineToPoint:
            mutablePath.addLine(to: points[i][0])
            break
        case .addQuadCurveToPoint:
            mutablePath.addQuadCurve(to: points[i][0], control: points[i][1])
            break
        case .addCurveToPoint:
            mutablePath.addCurve(to: points[i][0], control1: points[i][1], control2: points[i][2])
            break
        default:
            mutablePath.closeSubpath()
            break
        }
    }
    return mutablePath
}
