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
    if tool == .rectangle {
        let w = points[0][1].x > points[0][0].x ? points[0][1].x - points[0][0].x : points[0][0].x - points[0][1].x
        let h = points[0][1].y > points[0][0].y ? points[0][1].y - points[0][0].y : points[0][0].y - points[0][1].y
        let size = CGSize(width: w, height: h)
        var origin = CGPoint()
        
        if points[0][1].x > points[0][0].x && points[0][1].y > points[0][0].y {
            origin = points[0][0]
        } else if points[0][1].x > points[0][0].x && points[0][1].y <= points[0][0].y {
            origin = points[0][1]
        } else if points[0][1].x <= points[0][0].x && points[0][1].y > points[0][0].y {
            origin = points[1][0]
        } else {
            origin = points[1][1]
        }
        
        let dest = CGRect(origin: origin, size: size)
        mutablePath.addRect(dest)
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
