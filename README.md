# Canvas

[![CI Status](http://img.shields.io/travis/authman2/Canvas.svg?style=flat)](https://travis-ci.org/authman2/Canvas)
[![Version](https://img.shields.io/cocoapods/v/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas)
[![License](https://img.shields.io/cocoapods/l/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas)
[![Platform](https://img.shields.io/cocoapods/p/Canvas.svg?style=flat)](http://cocoapods.org/pods/Canvas)

Canvas is an iOS library for drawing lines and other shapes on the screen easily and efficiently.

## Usage

Here is a simple example to show how Canvas can be used in your app.
```swift
import UIKit

// 1.) Import Canvas
import Canvas


// 2.) Add the CanvasDelegate protocol (Optional).
class Home: UIViewController, CanvasDelegate {


// 3.) Create a new, blank Canvas.
lazy var canvas: Canvas = {
let a = Canvas()
a.translatesAutoresizingMaskIntoConstraints = false
a.backgroundColor = .white
a.delegate = self
a.isAntiAliasEnabled = true

return a
}()


// 4.) Create a new Brush to use when drawing on the Canvas (Optional).
let newBrush: Brush = {
let a = Brush()
a.color = .purple
a.thickness = 5
a.opacity = 0.5
a.flatness = 0.7
a.joinStyle = .bevel

return a
}()



// 5.) Add the Canvas to the view.
override func viewDidLoad() {
super.viewDidLoad()
view.addSubview(canvas)

canvas.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
canvas.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
canvas.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
canvas.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true


// 6.) Change the current Brush (Optional).
canvas.setCurrentBrush(brush: newBrush)
}


// 7.) Add the CanvasDelegate methods (Optional).
func didBeginDrawing(_ canvas: Canvas) {
print("Started drawing.")
}

func isDrawing(_ canvas: Canvas) {
print("Currently drawing...")
}

func didEndDrawing(_ canvas: Canvas) {
print("Finished drawing!")
}

}
```


## Installation

Canvas is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Canvas'
```

## Author
- Year: 2018
- Languages/Tools: Swift
- Programmer: Adeola Uthman

## License

Canvas is available under the MIT license. See the LICENSE file for more info.

