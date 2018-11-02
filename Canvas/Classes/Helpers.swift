//
//  Helpers.swift
//  Canvas
//
//  Created by Adeola Uthman on 11/1/18.
//

import Foundation


infix operator **
func **(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
    return pow(lhs, rhs)
}
func **(lhs: Int, rhs: Int) -> Int {
    return Int(pow(CGFloat(lhs), CGFloat(rhs)))
}
