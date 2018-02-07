# <img src="https://github.com/Authman2/Canvas/blob/master/CanvasLogo.png" width='60px' height='60px' /> &nbsp; Canvas

[![Version](https://img.shields.io/cocoapods/v/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas+)
[![License](https://img.shields.io/cocoapods/l/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas+)
[![Platform](https://img.shields.io/cocoapods/p/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas+)

Canvas is an iOS library for drawing lines and other shapes on the screen easily and efficiently.

# Docs
## Canvas
- **currentBrush**: The type of Brush to use when drawing on the Canvas.
- **allowsDrawing**: Whether or not the user should be able to draw on the Canvas.
- **shouldCreateDefaultLayer**: Tells the Canvas whether or not it should create a default layer for the user to draw on. Otherwise the user can just create one manually.
- **undo()**: Undo the last brush stroke.
- **redo()**: Redo the last brush stroke.
- **clear()**: Clear the current drawing layer.
- **addDrawingLayer(CanvasLayer, LayerPosition)**:  Add and switch to a new layer on top of the current one. Optional parameter to add the layer above or below the current one.
- **switchLayer(to)**: Switch to the specified layer for drawing.
- **moveLayer(at, to)**: Moves the layer at the given index to the second paramater index.
- **removeLayer(at)**: Removes the layer at the given index.
- **hideLayer(at)**: Hides the layer at the given index.
- **showLayer(at)**: Shows the layer at the given index.
- **getLayers()**: Returns an array of the CanvasLayers on the Canvas.
- **getCurrentLayer()**: Returns the current layer object.
- **getCurrentLayer()**: Returns the index of the current layer.

## CanvasLayer
- **isAntiAliasEnabled**: Whether or not the Canvas should have anti-aliasing enabled.
- **alllowsDrawing**: Whether or not the user can draw on this layer specifically as opposed to the entire Canvas.

## Brush
- **Default**: The default brush to use when drawing on the canvas.
- **Eraser**: An eraser brush that works out of the box. The user can still define their own eraser brush.

## CanvasDelegate
- **didBeginDrawing(canvas)**: Called when the user starts drawing on the Canvas.
- **isDrawing(canvas)**: Called (multiple times) while the user is drawing.
- **didEndDrawing(canvas)**: Called when the user stops drawing on the Canvas.


## Installation

Canvas is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Canvas+'
```

## Author
- Year: 2018
- Languages/Tools: Swift
- Programmer: Adeola Uthman

## License

Canvas is available under the MIT license. See the LICENSE file for more info.

