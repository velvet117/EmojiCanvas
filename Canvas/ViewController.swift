//
//  ViewController.swift
//  Canvas
//
//  Created by Anastasia Blodgett on 11/3/16.
//  Copyright © 2016 Anastasia Blodgett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var winkFaceImage: UIImageView!
    @IBOutlet weak var toungeFaceImageView: UIImageView!
    @IBOutlet weak var sadFaceImageView: UIImageView!
    @IBOutlet weak var happyFaceImageView: UIImageView!
    @IBOutlet weak var excitedFaceImage: UIImageView!
    @IBOutlet weak var downArrowImage: UIImageView!
    @IBOutlet weak var deadFaceImage: UIImageView!
    @IBOutlet weak var trayView: UIView!
    
    
    var newlyCreatedFace : UIImageView!
    var trayOriginalCenter : CGPoint?
    var trayCenterWhenOpen: CGPoint?
    var trayCenterWhenClosed: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayCenterWhenClosed = CGPoint(x: parentView.center.x, y: parentView.frame.height + (trayView.frame.height/2) - 40)
        trayCenterWhenOpen = CGPoint(x: parentView.center.x, y: parentView.frame.height - (trayView.frame.height/2))
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTrayPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = panGestureRecognizer.location(in: parentView)
        
        if panGestureRecognizer.state == .began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == .changed {
            print("Gesture changed at: \(point)")
            let translation = panGestureRecognizer.translation(in: parentView)
            trayView.center = CGPoint(x: trayOriginalCenter!.x, y: trayOriginalCenter!.y + translation.y)
        } else if panGestureRecognizer.state == .ended {
            let velocity = panGestureRecognizer.velocity(in: parentView)
            if velocity.y > 0 {
                trayView.center = trayCenterWhenClosed!
            }
            else {
                let someVar = CGPoint(x:trayCenterWhenOpen!.x, y:trayCenterWhenOpen!.y - 40)
                
                self.trayView.center = someVar
                UIView.animate(withDuration: 1,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 50,
                               options: [],
                    animations: {
                        self.trayView.center = self.trayCenterWhenOpen!
                    },
                    completion: nil)
            }
            print("Gesture ended at: \(point)")
        }
    }
    
    @objc private func panningFaces(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        let imageView = panGestureRecognizer.view as! UIImageView
        
        if panGestureRecognizer.state == .began {
            
            imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        else if panGestureRecognizer.state == .changed {
            
            
            imageView.center = panGestureRecognizer.location(in: parentView)
        }
        else if panGestureRecognizer.state == .ended {
            
            imageView.transform = CGAffineTransform(scaleX: -1, y: -1)

        }
    }

    @objc private func pinchingFaces(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        
        let imageView = pinchGestureRecognizer.view as! UIImageView
        
        imageView.transform = CGAffineTransform(scaleX: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
        
        

    }
    
    @objc private func deleteFace(_ doubleTap: UITapGestureRecognizer){
        let imageView = doubleTap.view as! UIImageView
        imageView.removeFromSuperview()
    }

    @IBAction func faceDragger(_ panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .began {
            // Gesture recognizers know the view they are attached to
            let imageView = panGestureRecognizer.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            let newGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panningFaces(_:)))
            let newPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchingFaces(_:)))
            
            let newDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteFace(_:)))
            newDoubleTapRecognizer.numberOfTapsRequired = 2
            
            newlyCreatedFace.isUserInteractionEnabled = true
            
            newlyCreatedFace.addGestureRecognizer(newDoubleTapRecognizer)
            newlyCreatedFace.addGestureRecognizer(newPinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(newGestureRecognizer)
            
        } else if panGestureRecognizer.state == .changed {
            
            newlyCreatedFace.center = panGestureRecognizer.location(in: parentView)
            
        } else if panGestureRecognizer.state == .ended {
            
        }
        
    }
}

