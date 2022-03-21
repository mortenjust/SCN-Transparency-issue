//
//  ViewController.swift
//  SCN Transparent
//
//  Created by Morten Just on 3/21/22.
//

import Cocoa
import AppKit
import SceneKit

class ViewController: NSViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    var scene : SCNScene { sceneView.scene! }
    
    
    
    var downloads : URL { FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0] }
    var destination : URL { downloads.appendingPathComponent("Render \(UUID().uuidString).png") }
    
    @IBAction func clicked(_ sender: Any) {
        
        scene.background.contents = NSColor.clear
        
        let snapshotRenderer = SCNRenderer(device: MTLCreateSystemDefaultDevice())
        snapshotRenderer.pointOfView = sceneView.pointOfView
        snapshotRenderer.scene = scene
        snapshotRenderer.scene!.background.contents = NSColor.clear
        snapshotRenderer.autoenablesDefaultLighting = true
        
        // setting this to false does not make the image semi-transparent
        snapshotRenderer.isJitteringEnabled = false
        
        let size = CGSize(width: 1000, height: 1000)
        
        let image = snapshotRenderer.snapshot(atTime: .zero, with: size, antialiasingMode: .multisampling16X)
     
        let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
        let pngData = imageRep?.representation(using: .png, properties: [:])
        try! pngData!.write(to: destination)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.scene = SCNScene()
        
        sceneView.autoenablesDefaultLighting = true
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.materials.first?.diffuse.contents = NSColor.white

        let node = SCNNode(geometry: box)
        node.eulerAngles = SCNVector3(10, 25, 210)

        scene.rootNode.addChildNode(node)
        
        sceneView.allowsCameraControl = true

        
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


