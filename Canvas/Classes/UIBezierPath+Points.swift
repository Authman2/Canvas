//
//  UIBezierPath+Points.swift
//  Canvas
//
//  Created by Adeola Uthman on 3/12/18.
//

import Foundation

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
    
    var bezierPointsAndTypes: [([CGPoint], CGPathElementType)] {
        var ret: [([CGPoint], CGPathElementType)] = []
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
    
    
//    static func interpolateHermiteFor(points: [CGPoint], closed: Bool = false) -> UIBezierPath {
//        guard points.count >= 2 else {
//            return UIBezierPath()
//        }
//        
//        if points.count == 2 {
//            let bezierPath = UIBezierPath()
//            bezierPath.move(to: points[0])
//            bezierPath.addLineToPoint(points[1])
//            return bezierPath
//        }
//        
//        let nCurves = closed ? points.count : points.count - 1
//        
//        let path = UIBezierPath()
//        for i in 0..<nCurves {
//            var curPt = points[i]
//            var prevPt: CGPoint, nextPt: CGPoint, endPt: CGPoint
//            if i == 0 {
//                path.moveToPoint(curPt)
//            }
//            
//            var nexti = (i+1)%points.count
//            var previ = (i-1 < 0 ? points.count-1 : i-1)
//            
//            prevPt = points[previ]
//            nextPt = points[nexti]
//            endPt = nextPt
//            
//            var mx: CGFloat
//            var my: CGFloat
//            if closed || i > 0 {
//                mx  = (nextPt.x - curPt.x) * CGFloat(0.5)
//                mx += (curPt.x - prevPt.x) * CGFloat(0.5)
//                my  = (nextPt.y - curPt.y) * CGFloat(0.5)
//                my += (curPt.y - prevPt.y) * CGFloat(0.5)
//            }
//            else {
//                mx = (nextPt.x - curPt.x) * CGFloat(0.5)
//                my = (nextPt.y - curPt.y) * CGFloat(0.5)
//            }
//            
//            var ctrlPt1 = CGPointZero
//            ctrlPt1.x = curPt.x + mx / CGFloat(3.0)
//            ctrlPt1.y = curPt.y + my / CGFloat(3.0)
//            
//            curPt = points[nexti]
//            
//            nexti = (nexti + 1) % points.count
//            previ = i;
//            
//            prevPt = points[previ]
//            nextPt = points[nexti]
//            
//            if closed || i < nCurves-1 {
//                mx  = (nextPt.x - curPt.x) * CGFloat(0.5)
//                mx += (curPt.x - prevPt.x) * CGFloat(0.5)
//                my  = (nextPt.y - curPt.y) * CGFloat(0.5)
//                my += (curPt.y - prevPt.y) * CGFloat(0.5)
//            }
//            else {
//                mx = (curPt.x - prevPt.x) * CGFloat(0.5)
//                my = (curPt.y - prevPt.y) * CGFloat(0.5)
//            }
//            
//            var ctrlPt2 = CGPointZero
//            ctrlPt2.x = curPt.x - mx / CGFloat(3.0)
//            ctrlPt2.y = curPt.y - my / CGFloat(3.0)
//            
//            path.addCurveToPoint(endPt, controlPoint1:ctrlPt1, controlPoint2:ctrlPt2)
//        }
//        
//        if closed {
//            path.closePath()
//        }
//        
//        return path
//    }
//    
    
    
    
}
