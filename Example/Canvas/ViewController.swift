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
    
    lazy var canvasView: Canvas = {
        let a = Canvas()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.backgroundColor = .white
        a.delegate = self
        
        return a
    }()
    
    let b: Brush = {
        let a = Brush()
        a.color = .purple
        a.thickness = 5
        a.opacity = 1
        a.flatness = 0.7
        a.joinStyle = .bevel
        return a
    }()
    
    let c: Brush = {
        let a = Brush()
        a.color = .green
        a.thickness = 10
        a.opacity = 1
        a.flatness = 1.5
        a.joinStyle = .round
        return a
    }()
    
    let d: Brush = {
        let a = Brush()
        a.color = .orange
        a.thickness = 2
        a.opacity = 1
        a.flatness = 0.1
        a.joinStyle = .miter
        return a
    }()
    
    
    
    
    lazy var colorBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Change Brush (Random)", for: .normal)
        a.backgroundColor = UIColor.gray
        a.addTarget(self, action: #selector(brush), for: .touchUpInside)
        
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
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    func didBeginDrawing(_ canvas: Canvas) {
        
    }
    
    func isDrawing(_ canvas: Canvas) {
        
    }
    
    func didEndDrawing(_ canvas: Canvas) {
        
    }
    
    
    
    @objc func brush() {
        let brushes = [Brush.Default, b, c, d, Brush.Eraser]
        let rand = Int(arc4random_uniform(UInt32(brushes.count)))
        canvasView.currentBrush = brushes[rand]
    }
    
    @objc func undo() {
        canvasView.undo()
    }
    
    @objc func redo() {
        canvasView.redo()
    }
    
    @objc func addLayer() {
        canvasView.addDrawingLayer(layer: CanvasLayer())
    }
    
    @objc func switchLayer() {
        let rand = Int(arc4random_uniform(UInt32(canvasView.getLayers().count)))
        canvasView.switchLayer(to: rand)
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
        switchLayerBtn.heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
    

}

