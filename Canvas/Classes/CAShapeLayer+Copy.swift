//
//  CAShapeLayer+Copy.swift
//  Canvas
//
//  Created by Adeola Uthman on 6/17/18.
//

import Foundation

public extension CAShapeLayer {
    
    open override func mutableCopy() -> Any {
        let a = CAShapeLayer()
        a.fillColor = fillColor
        a.strokeColor = strokeColor
        a.lineCap = lineCap
        a.lineJoin = lineJoin
        a.lineWidth = lineWidth
        a.miterLimit = miterLimit
        a.path = path
        a.position = position
        a.bounds = bounds
        a.opacity = opacity
        a.fillRule = fillRule
        
        return a
    }
    
}
