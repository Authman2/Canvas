//
//  Canvas.swift
//  Canvas
//
//  Created by Adeola Uthman on 10/7/18.
//

import Foundation

/** An area of the screen that allows drawing. */
public class Canvas: UIView {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    // -- PRIVATE VARS
    
    /** What type of canvas this is. */
    internal var type: CanvasType!
    
    /** The touch points. */
    internal var currentPoint: CGPoint = CGPoint()
    internal var lastPoint: CGPoint = CGPoint()
    internal var lastLastPoint: CGPoint = CGPoint()
    
    /** A collection of the layers on this canvas. */
    internal var _canvasLayers: [CanvasLayer] = []
    internal var _currentCanvasLayer: Int = 0
    
    
    
    
    // -- PUBLIC VARS
    
    /** Events delegate. */
    public var delegate: CanvasEvents?
    
    
    
    
    // -- COMPUTED PROPS
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init(type: CanvasType, createDefaultLayer: Bool) {
        super.init(frame: CGRect.zero)
        setup(type: type, createDefaultLayer: createDefaultLayer)
    }
    
    public init(createDefaultLayer: Bool) {
        super.init(frame: CGRect.zero)
        setup(createDefaultLayer: createDefaultLayer)
    }
    
    public init(type: CanvasType) {
        super.init(frame: CGRect.zero)
        setup(type: type)
    }
    
    private func setup(type: CanvasType = .vector, createDefaultLayer: Bool = false) {
        self.type = type
        
        if createDefaultLayer == true {
            let defLay = CanvasLayer()
            self.addLayer(newLayer: defLay, position: .above)
        }
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    
}
