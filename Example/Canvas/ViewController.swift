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
        a.isAntiAliasEnabled = true
        
        return a
    }()
    
    let b: Brush = {
        let c = Brush()
        c.color = .purple
        c.thickness = 5
        c.opacity = 1
        c.flatness = 0.7
        c.joinStyle = .bevel
        return c
    }()
    
    let d: Brush = {
        let c = Brush()
        c.color = .green
        c.thickness = 5
        c.opacity = 1
        c.flatness = 0.7
        c.joinStyle = .bevel
        return c
    }()
    
    let e: Brush = {
        let c = Brush()
        c.color = .red
        c.thickness = 5
        c.opacity = 1
        c.flatness = 0.7
        c.joinStyle = .bevel
        return c
    }()
    
    
    lazy var brushes = [b, d, e]
    
    
    lazy var undoBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Undo", for: .normal)
        a.backgroundColor = .blue
        a.layer.cornerRadius = 15
        a.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        return a
    }()
    
    lazy var redoBtn: UIButton = {
        let a = UIButton()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.setTitle("Redo", for: .normal)
        a.backgroundColor = .blue
        a.layer.cornerRadius = 15
        a.addTarget(self, action: #selector(redo), for: .touchUpInside)
        
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
        view.addSubview(undoBtn)
        view.addSubview(redoBtn)
        
        setupLayout()
    }
    
    
    
    
    /************************
     *                      *
     *       FUNCTIONS      *
     *                      *
     ************************/
    
    func didBeginDrawing(_ canvas: Canvas) {
        let rand = Int(arc4random_uniform(UInt32(brushes.count)))
        canvas.currentBrush = brushes[rand]
    }
    
    func isDrawing(_ canvas: Canvas) {
        
    }
    
    func didEndDrawing(_ canvas: Canvas) {
        
    }
    
    
    
    @objc func undo() {
        canvasView.undo()
    }
    
    @objc func redo() {
//        canvasView.redo()
        canvasView.clear()
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
        canvasView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
        undoBtn.topAnchor.constraint(equalTo: canvasView.bottomAnchor).isActive = true
        undoBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        undoBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        undoBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        redoBtn.topAnchor.constraint(equalTo: canvasView.bottomAnchor).isActive = true
        redoBtn.leadingAnchor.constraint(equalTo: undoBtn.trailingAnchor).isActive = true
        redoBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        redoBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    

}

