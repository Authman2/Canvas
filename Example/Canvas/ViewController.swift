//
//  ViewController.swift
//  Canvas
//
//  Created by authman2 on 01/12/2018.
//  Copyright (c) 2018 authman2. All rights reserved.
//

import UIKit
import Canvas

class ViewController: UIViewController, CanvasDelegate {
    
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
    
    lazy var undoBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Undo", for: .normal)
        a.backgroundColor = UIColor.gray
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
    
    lazy var addLayerBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Add Layer", for: .normal)
        a.backgroundColor = UIColor.gray
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
        view.addSubview(addLayerBtn)
        view.addSubview(switchLayerBtn)
        
        setupLayout()
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
        canvas.setTool(tool: CanvasTool.line)
    }
    
    
    
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    @objc func newColor() {
        let c: [UIColor] = [.green, .red, .blue, .orange, .purple]
        let rand = Int(arc4random_uniform(UInt32(c.count)))
        
        canvas.currentBrush.color = c[rand]
        canvas.currentBrush.thickness = canvas.currentBrush.thickness == 10 ? 5 : 10
    }
    
    @objc func undo() {
        
    }
    
    @objc func redo() {
        
    }
    
    @objc func addLayer() {
        let n = CanvasLayer()
        canvas.addDrawingLayer(newLayer: n, position: .above)
    }
    
    @objc func switchLayer() {
        let rand = Int(arc4random_uniform(UInt32(canvas.canvasLayers.count)))
        canvas.switchLayer(to: rand)
    }
    
    
    
    
    
    
    
    
    
    /************************
     *                      *
     *        LAYOUT        *
     *                      *
     ************************/
    
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
        colorBtn.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        colorBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor).isActive = true
        colorBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        undoBtn.topAnchor.constraint(equalTo: colorBtn.bottomAnchor).isActive = true
        undoBtn.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        undoBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor).isActive = true
        undoBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        redoBtn.topAnchor.constraint(equalTo: undoBtn.bottomAnchor).isActive = true
        redoBtn.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        redoBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor).isActive = true
        redoBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        addLayerBtn.topAnchor.constraint(equalTo: redoBtn.bottomAnchor).isActive = true
        addLayerBtn.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        addLayerBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor).isActive = true
        addLayerBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true

        switchLayerBtn.topAnchor.constraint(equalTo: addLayerBtn.bottomAnchor).isActive = true
        switchLayerBtn.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        switchLayerBtn.widthAnchor.constraint(equalTo: canvasView.widthAnchor).isActive = true
        switchLayerBtn.heightAnchor.constraint(equalToConstant: 67).isActive = true
    }
    
    
}

