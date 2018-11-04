//
//  UITouch+Translation.swift
//  Canvas
//
//  Created by Adeola Uthman on 11/4/18.
//

import Foundation

extension UITouch {
    private struct AssociatedKeys {
        static var dX: Int = 0
        static var dY: Int = 0
    }
    
    /** The amount that the touch has changed in the x direction from the moment it was last on the screen. */
    var deltaX: CGFloat {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.dX) as? CGFloat ?? 0 }
        set { objc_setAssociatedObject(self, &AssociatedKeys.dX, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    /** The amount that the touch has changed in the y direction from the moment it was last on the screen. */
    var deltaY: CGFloat {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.dY) as? CGFloat ?? 0 }
        set { objc_setAssociatedObject(self, &AssociatedKeys.dY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    /** The amount that the touch has changed from the moment it was last on the screen. */
    var translation: CGFloat {
        return CGFloat(sqrt((deltaX ** 2) + (deltaY ** 2)))
    }
}
