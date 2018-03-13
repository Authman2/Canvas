//
//  UIBezierPath+Points.swift
//  Canvas
//
//  Created by Adeola Uthman on 3/12/18.
//

import Foundation

typealias BezierPoints = [CGPoint]
extension CGPath {
    
    func forEach( body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    
    var bezierPoints:[CGPoint] {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            default: break
            }
        }
        return arrayPoints
    }
    
    var bezierPointsAndTypes: [(BezierPoints, CGPathElementType)] {
        var ret: [(BezierPoints, CGPathElementType)] = []
        self.forEach { element in
            switch (element.type) {
            case .moveToPoint:
                ret.append(([element.points[0]], element.type))
            case .addLineToPoint:
                ret.append(([element.points[0]], element.type))
            case .addQuadCurveToPoint:
                ret.append(([element.points[0], element.points[1]], element.type))
            case .addCurveToPoint:
                ret.append(([element.points[0], element.points[1], element.points[2]], element.type))
            default: break
            }
        }
        return ret
    }
}
