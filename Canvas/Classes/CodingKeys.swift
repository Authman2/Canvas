//
//  CodingKeys.swift
//  Canvas
//
//  Created by Adeola Uthman on 5/4/18.
//

import Foundation

enum CanvasCodingKeys: CodingKey {
    case canvasDrawingTool
    case canvasDrawingBrush
    case canvasCurrentPoint
    case canvasLastPoint
    case canvasLastLastPoint
    case canvasUndoRedoManager
    case canvasLayers
    case canvasCurrentLayer
    case canvasCreateDefaultLayer
    case canvasCopiedNode
    case canvasAllowsMultipleTouches
    case canvasPreemptTouches
}

enum CanvasLayerCodingKeys: CodingKey {
    case canvasLayerCanvas
    case canvasLayerNextNode
    case canvasLayerDrawImage
    case canvasLayerBackgroundImage
    case canvasLayerNodeArray
    case canvasLayerIsVisible
    case canvasLayerAllowsDrawing
    case canvasLayerOpacity
    case canvasLayerName
}

enum BrushCodingKeys: CodingKey {
    case brushColor
    case brushThickness
    case brushOpacity
    case brushFlatness
    case brushMiter
    case brushShape
    case brushJoinStyle
}

enum NodeCodingKeys: CodingKey {
    case nodePath
    case nodeBrush
    case nodeFirstPoint
    case nodeLastPoint
    case nodeID
    case nodePoints
    case nodeBoundingBox
    case nodeInnerRect
    case nodeAllowsSelection
    case nodeShapeLayer
}
