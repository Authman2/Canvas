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
    case canvasLayerImportedImage
    case canvasLayerNodeArray
    case canvasLayerIsVisible
    case canvasLayerAllowsDrawing
    case canvasLayerOpacity
    case canvasLayerTint
    case canvasLayerName
    case canvasLayerPoints
    case canvasLayerTypes
    case canvasLayerTransformBox
}

enum BrushCodingKeys: CodingKey {
    case brushColor
    case brushThickness
    case brushOpacity
    case brushMiter
    case brushShape
    case brushJoinStyle
}

enum NodeCodingKeys: CodingKey {
    case nodeFirstPoint
    case nodeLastPoint
    case nodeBoundingBox
    case nodeMovable
    case nodeType
    case nodePoints
    case nodeTypes
    case nodeBezPoints
    case nodeBezTypes
    case nodeFill
    case nodeStroke
    case nodeLineCap
    case nodeLineJoin
    case nodeLineWidth
    case nodeMiter
    case nodeBounds
    case nodePosition
}



