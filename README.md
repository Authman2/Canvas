# <img src="https://github.com/Authman2/Canvas/blob/master/CanvasLogo.png" width='60px' height='60px' /> &nbsp; Canvas

[![Version](https://img.shields.io/cocoapods/v/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas+)
[![License](https://img.shields.io/cocoapods/l/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas+)
[![Platform](https://img.shields.io/cocoapods/p/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas+)

Canvas is an iOS library that creates an area on the screen where the user can draw lines and shapes, style drawings by adding different types of brushes, and work with multiple layers. It provides an easy way to add on-screen drawing to any iOS app. Canvas uses SVG graphics for drawing, meaning that there is no loss of quality when the resolution changes.

## Features
- **Canvas**: A UIView with a clear background where users can draw using SVG graphics.
- **CanvasTools**: Draw using different shapes (pen, eraser, line, rectangle, ellipse, and eyedropper)
- **CanvasLayers**: Create multiple drawing layers that can be moved, swapped, hidden, locked, and more.
- **Brushes**: Create and use different brushes to style drawings on the canvas.
- **Protocols**: Keep track of when the user starts drawing, is drawing, and finishes drawing by using the CanvasProtocol.
- **Import/Export**: Import multiple UIImages as CanvasLayers, then export your canvas drawing as a UIImage.
- **Undo/Redo/Clear**: Support for undo, redo, and clearing of drawings. You can also define for yourself what actions in your app should count toward to the undo/redo stack by using the addCustomUndoRedo function.
- **Selection Tool**: Select different drawing strokes and move them around the canvas. Drawings can also be copied and pasted onto different canvas layers.
- **Codable**: The objects that make up the Canvas implement the Codable protocol, meaning you can encode and decode them to fit your app's needs.

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


