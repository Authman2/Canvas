//
//  ViewController.swift
//  Canvas
//
//  Created by authman2 on 01/12/2018.
//  Copyright (c) 2018 authman2. All rights reserved.
//

import UIKit
import Canvas

class ViewController: UIViewController, CanvasDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /************************
     *                      *
     *       VARIABLES      *
     *                      *
     ************************/
    
    /** The background holder for the canvas so that it can have a white background. */
    lazy var canvasView: UIView = {
        let a = UIView()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.backgroundColor = .white
        
        return a
    }()
    
    
    /** The actual canvas, which has a clear background. */
    lazy var canvas: Canvas = {
        let a = Canvas()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.delegate = self
        a.preemptTouch = false
        
        return a
    }()
    
    
    
    
    lazy var colorBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Change Brush (Random)", for: .normal)
        a.backgroundColor = UIColor.gray
        a.addTarget(self, action: #selector(newColor), for: .touchUpInside)
        
        return a
    }()
    
    lazy var toolBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Change Tool (Random)", for: .normal)
        a.backgroundColor = UIColor.lightGray
        a.addTarget(self, action: #selector(newTool), for: .touchUpInside)
        
        return a
    }()
    
    lazy var undoBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Undo", for: .normal)
        a.backgroundColor = UIColor.lightGray
        a.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        return a
    }()
    
    lazy var redoBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Redo", for: .normal)
        a.backgroundColor = UIColor.gray
        a.addTarget(self, action: #selector(redo), for: .touchUpInside)
        
        return a
    }()
    
    lazy var clearBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Clear", for: .normal)
        a.backgroundColor = UIColor.gray
        a.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        return a
    }()
    
    lazy var addLayerBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Add Layer", for: .normal)
        a.backgroundColor = UIColor.lightGray
        a.addTarget(self, action: #selector(addLayer), for: .touchUpInside)
        
        return a
    }()
    
    lazy var switchLayerBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Switch Layer (Random)", for: .normal)
        a.backgroundColor = UIColor.gray
        a.addTarget(self, action: #selector(switchLayer), for: .touchUpInside)
        
        return a
    }()
    
    lazy var importBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Import Image", for: .normal)
        a.backgroundColor = UIColor.gray
        a.addTarget(self, action: #selector(importImage), for: .touchUpInside)
        
        return a
    }()
    
    lazy var exportBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Export Image", for: .normal)
        a.backgroundColor = UIColor.lightGray
        a.addTarget(self, action: #selector(exportImage), for: .touchUpInside)
        
        return a
    }()
    
    lazy var selectBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Select Tool", for: .normal)
        a.backgroundColor = UIColor.lightGray
        a.addTarget(self, action: #selector(selectTool), for: .touchUpInside)
        
        return a
    }()
    
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *         INIT         *
     *                      *
     ************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        canvasView.addSubview(canvas)
        view.addSubview(canvasView)
        view.addSubview(colorBtn)
        view.addSubview(undoBtn)
        view.addSubview(redoBtn)
        view.addSubview(clearBtn)
        view.addSubview(addLayerBtn)
        view.addSubview(switchLayerBtn)
        view.addSubview(toolBtn)
        view.addSubview(importBtn)
        view.addSubview(exportBtn)
        view.addSubview(selectBtn)
        
        setupLayout()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoom(sender:)))
        view.addGestureRecognizer(pinch)
    }
    
    
    
    
    /************************
     *                      *
     *        DELEGATE      *
     *                      *
     ************************/
    
    func didBeginDrawing(on canvas: Canvas, withTool tool: CanvasTool) {
        
    }
    
    func isDrawing(on canvas: Canvas, withTool tool: CanvasTool) {
        
    }
    
    func didEndDrawing(on canvas: Canvas, withTool tool: CanvasTool) {
        
    }
    
    func didSelectNode(on canvas: Canvas, selectedNode: Node) {
        
    }
    
    func didCopyNode(on canvas: Canvas, copiedNode: Node?) {
        
    }
    
    func didPasteNode(on canvas: Canvas, pastedNode: Node) {
        
    }
    
    func didMoveNode(on canvas: Canvas, movedNodes: [Node]) {
        
    }
    
    func didSelectNodes(on canvas: Canvas, selectedNodes: [Node]) {
        if selectedNodes.count > 0 {
            print(selectedNodes[0].toSVG())
        }
//        canvas.fillSelectedNodes(with: .green)
//        canvas.strokeSelectedNodes(with: .orange)
    }
    
    func didChangeFill(on canvas: Canvas, filledNodes: [Node], fillColor: UIColor) {
        
    }
    
    func didChangeStroke(on canvas: Canvas, paintedNodes: [Node], strokeColor: UIColor) {
        
    }
    
    func didSampleColor(on canvas: Canvas, color: UIColor) {
        
    }
    
    func didUndo(on canvas: Canvas) {
        
    }
    
    func didRedo(on canvas: Canvas) {
        
    }
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    @objc func newColor() {
        let c: [UIColor] = [.green, .red, .blue, .orange, .purple]
        let rand = Int(arc4random_uniform(UInt32(c.count)))
        
        let nBrush: Brush = {
            var a = Brush()
            a.color = c[rand]
            a.thickness = canvas.currentBrush.thickness == 10 ? 5 : 10
            return a
        }()
        canvas.setBrush(brush: nBrush)
        
        alert(title: "Switched Brush", message: "You are now using a brush with color \(nBrush.color.rgba) and size \(nBrush.thickness)")
    }
    
    @objc func newTool() {
        let tools: [CanvasTool] = [.pen, .eraser, .line, .rectangle, .ellipse, .eyedropper]
        let rand = Int(arc4random_uniform(UInt32(tools.count)))
        
        let last = canvas.currentTool
        canvas.setTool(tool: tools[rand])
        
        // Changing the tool will be counted as an undo/redo action.
        canvas.addCustomUndoRedo(cUndo: {
            self.canvas.setTool(tool: last)
        }) {
            self.canvas.setTool(tool: tools[rand])
        }

        alert(title: "Switched Tool", message: "You are now using the \(canvas.currentTool) tool.")
    }
    
    @objc func selectTool() {
        canvas.setTool(tool: CanvasTool.selection)
        alert(title: "Switched Tool", message: "You are now using the \(canvas.currentTool) tool.")
    }
    
    @objc func undo() {
        canvas.undo()
    }
    
    @objc func redo() {
        canvas.redo()
    }
    
    @objc func clear() {
        canvas.clear()
    }
    
    @objc func addLayer() {
        let n = CanvasLayer(canvas: canvas)
        n.name = "Layer \(canvas.canvasLayers.count)"
        canvas.addDrawingLayer(newLayer: n, position: .below)
        
        alert(title: "New Layer", message: "Added a new layer to the canvas.")
    }
    
    @objc func switchLayer() {
        let rand = Int(arc4random_uniform(UInt32(canvas.canvasLayers.count)))
        canvas.switchLayer(to: rand)
        
        alert(title: "Switched Layer", message: "You are now on layer \(canvas.currentLayerIndex)")
    }
    
    @objc func importImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker: UIImagePickerController = {
                let a = UIImagePickerController()
                a.delegate = self
                a.sourceType = .photoLibrary
                a.allowsEditing = false
                return a
            }()
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func exportImage() {
        canvas.export { (img: UIImage) in
            UIImageWriteToSavedPhotosAlbum(img, self, nil, nil)
        }
        
        // Alert export success.
        alert(title: "Exported!", message: "Your drawing has been saved to the photo album.")
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        canvas.importImage(image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        self.show(alert, sender: self)
    }
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
    @objc func zoom(sender: UIPinchGestureRecognizer) {
        let transform = canvas.transform.scaledBy(x: sender.scale, y: sender.scale)
        canvas.transform = transform
        sender.scale = 1.0
    }
    
    
    func setupLayout() {
        canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        canvasView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        canvasView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        canvasView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        canvas.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        canvas.topAnchor.constraint(equalTo: canvasView.topAnchor).isActive = true
        canvas.widthAnchor.constraint(equalTo: canvasView.widthAnchor).isActive = true
        canvas.heightAnchor.constraint(equalTo: canvasView.heightAnchor).isActive = true
        
        colorBtn.topAnchor.constraint(equalTo: canvasView.bottomAnchor).isActive = true
        colorBtn.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor).isActive = true
        colorBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        colorBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        undoBtn.topAnchor.constraint(equalTo: colorBtn.bottomAnchor).isActive = true
        undoBtn.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor).isActive = true
        undoBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        undoBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        redoBtn.topAnchor.constraint(equalTo: undoBtn.bottomAnchor).isActive = true
        redoBtn.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor).isActive = true
        redoBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        redoBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        addLayerBtn.topAnchor.constraint(equalTo: redoBtn.bottomAnchor).isActive = true
        addLayerBtn.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor).isActive = true
        addLayerBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        addLayerBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        switchLayerBtn.topAnchor.constraint(equalTo: addLayerBtn.bottomAnchor).isActive = true
        switchLayerBtn.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor).isActive = true
        switchLayerBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        switchLayerBtn.heightAnchor.constraint(equalToConstant: 67).isActive = true
        
        toolBtn.topAnchor.constraint(equalTo: canvasView.bottomAnchor).isActive = true
        toolBtn.leadingAnchor.constraint(equalTo: colorBtn.trailingAnchor).isActive = true
        toolBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        toolBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        importBtn.topAnchor.constraint(equalTo: toolBtn.bottomAnchor).isActive = true
        importBtn.leadingAnchor.constraint(equalTo: colorBtn.trailingAnchor).isActive = true
        importBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        importBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        exportBtn.topAnchor.constraint(equalTo: importBtn.bottomAnchor).isActive = true
        exportBtn.leadingAnchor.constraint(equalTo: colorBtn.trailingAnchor).isActive = true
        exportBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        exportBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        clearBtn.topAnchor.constraint(equalTo: exportBtn.bottomAnchor).isActive = true
        clearBtn.leadingAnchor.constraint(equalTo: colorBtn.trailingAnchor).isActive = true
        clearBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        clearBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        selectBtn.topAnchor.constraint(equalTo: clearBtn.bottomAnchor).isActive = true
        selectBtn.leadingAnchor.constraint(equalTo: colorBtn.trailingAnchor).isActive = true
        selectBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 0.5).isActive = true
        selectBtn.heightAnchor.constraint(equalToConstant: 67).isActive = true
    }
    
    
}

