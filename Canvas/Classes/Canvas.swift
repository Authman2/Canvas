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
    
    /** The touch points. */
    internal var currentPoint: CGPoint = CGPoint()
    internal var lastPoint: CGPoint = CGPoint()
    internal var lastLastPoint: CGPoint = CGPoint()
    
    /** The next node to be drawn on the canvas. */
    internal var nextNode: Node? = nil
    
    /** A collection of the layers on this canvas. */
    internal var _canvasLayers: [CanvasLayer] = []
    internal var _currentCanvasLayer: Int = 0
    
    /** The current brush that is being used to style drawings. */
    internal var _currentBrush: Brush = Brush.Default
    
    /** The current tool that is being used to draw. */
    internal var _currentTool: CanvasTool = CanvasTool.pen
    
    
    
    // -- PUBLIC VARS
    
    /** Events delegate. */
    public var delegate: CanvasEvents?
    
    /** The brush that is currently being used to style drawings. */
    public var currentBrush: Brush {
        set { _currentBrush = newValue }
        get { return _currentBrush }
    }
    
    /** The tool that is currently being used to draw on the canvas. */
    public var currentTool: CanvasTool {
        set { _currentTool = newValue }
        get { return _currentTool }
    }
    
    
    
    
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
    
    public init(createDefaultLayer: Bool) {
        super.init(frame: CGRect.zero)
        setup(createDefaultLayer: createDefaultLayer)
    }
    
    private func setup(createDefaultLayer: Bool = false) {
        if createDefaultLayer == true {
            let defLay = CanvasLayer(type: LayerType.raster)
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
     *        DRAWING       *
     *                      *
     ************************/
    
    public override func draw(_ rect: CGRect) {
        // 1.) Clear all sublayers.
        layer.sublayers = []
        
        // 2.) Go through each layer and render it using either raster or vector graphics.
        for i in (0..<self._canvasLayers.count).reversed() {
            let layer = self._canvasLayers[i]
            
            if layer.type == .raster {
                drawRaster(layer: layer, rect)
            } else {
                drawVector(layer: layer, rect)
            }
        }
        
        // 3.) Draw the temporary drawing.
        guard let next = nextNode else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = build(from: next.points, using: next.instructions, tool: next.type)
        context.addPath(path)
        context.setLineCap(self._currentBrush.shape)
        context.setLineJoin(self._currentBrush.joinStyle)
        context.setLineWidth(self._currentBrush.thickness)
        context.setStrokeColor(self._currentBrush.color.cgColor)
        context.setBlendMode(.normal)
        context.setMiterLimit(self._currentBrush.miter)
        context.setAlpha(self._currentBrush.opacity)
        context.strokePath()
    }
    
    private func drawRaster(layer: CanvasLayer, _ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Create a CGContext to draw all of the lines on that layer.
        for node in layer.drawings {
            // Draw using the context.
            let path = build(from: node.points, using: node.instructions, tool: node.type)
            
            context.addPath(path)
            context.setLineCap(self._currentBrush.shape)
            context.setLineJoin(self._currentBrush.joinStyle)
            context.setLineWidth(self._currentBrush.thickness)
            context.setStrokeColor(self._currentBrush.color.cgColor)
            context.setBlendMode(.normal)
            context.setMiterLimit(self._currentBrush.miter)
            context.setAlpha(self._currentBrush.opacity)
            context.strokePath()
        }
    }
    
    private func drawVector(layer: CanvasLayer, _ rect: CGRect) {
        for node in layer.drawings {
            let path = build(from: node.points, using: node.instructions, tool: node.type)
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = path.boundingBox
            shapeLayer.path = path
            //        shapeLayer.backgroundColor = UIColor.orange.cgColor
            shapeLayer.strokeColor = self._currentBrush.color.cgColor
            shapeLayer.fillRule = kCAFillRuleEvenOdd
            shapeLayer.fillMode = kCAFillModeBoth
            shapeLayer.fillColor = nil
            shapeLayer.opacity = Float(self._currentBrush.opacity)
            shapeLayer.lineWidth = self._currentBrush.thickness
            shapeLayer.miterLimit = self._currentBrush.miter
            
            var nPos = path.boundingBox.origin
            nPos.x += path.boundingBox.width / 2
            nPos.y += path.boundingBox.height / 2
            shapeLayer.position = nPos
            
            self.layer.addSublayer(shapeLayer)
        }
    }
    
}
