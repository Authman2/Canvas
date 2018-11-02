//
//  Canvas+Color.swift
//  Canvas
//
//  Created by Adeola Uthman on 11/1/18.
//

import Foundation

public extension Canvas {
    
    /** Handles grabbing a color from an area on the canvas. */
    func handleEyedrop(point: CGPoint) {
        // Only track the eyedropper on the canvas.
        if hitTest(point, with: nil) != self { return }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixels: [UInt8] = [0,0,0,0]
        
        if let context = CGContext(data: &pixels, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmap.rawValue) {
            
            context.translateBy(x: -point.x, y: -point.y)
            self.layer.render(in: context)
            
            let r = CGFloat(pixels[0])/CGFloat(255)
            let g = CGFloat(pixels[1])/CGFloat(255)
            let b = CGFloat(pixels[2])/CGFloat(255)
            let a = CGFloat(pixels[3])/CGFloat(255)
            
            let color = UIColor(red: r, green: g, blue: b, alpha: a)
            var nBrush: Brush = self._currentBrush
            nBrush.color = color
            self._currentBrush = nBrush
            self.delegate?.didSampleColor(on: self, sampledColor: color)
        }
    }
    
    
    
}
