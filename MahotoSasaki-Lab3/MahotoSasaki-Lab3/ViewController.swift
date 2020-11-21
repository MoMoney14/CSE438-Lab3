//
//  ViewController.swift
//  MahotoSasaki-Lab3
//
//  Created by Mahoto Sasaki on 9/13/20.
//  Copyright © 2020 mo3aru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentDrawing:Drawing?
    var drawingCanvas:DrawView!
    var color:UIColor = UIColor.red
    var strokeAlpha:CGFloat = 0.5
    
    var shortcutItemToProcess:UIApplicationShortcutItem?
    var window:UIWindow?
        
    @IBOutlet weak var strokeWidthSlider: UISlider!
    @IBOutlet weak var moreView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawingCanvas = DrawView(frame: view.frame)
        view.addSubview(drawingCanvas)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        if moreView.frame.contains(touchPoint) {
            if !moreView.isHidden {
                return
            }
        } else {
            moreView.isHidden = true
        }
        currentDrawing = Drawing(points: [touchPoint], thickness: CGFloat(strokeWidthSlider.value) * 20 + 1, color: color, opacity: strokeAlpha)
        drawingCanvas.currentDrawing = currentDrawing
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        if !moreView.isHidden {
           return
        }
        currentDrawing?.points.append(touchPoint)
        drawingCanvas.currentDrawing = currentDrawing
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !moreView.isHidden {
           return
        } else {
            if let currentDrawing = currentDrawing {
                drawingCanvas.drawings.append(currentDrawing)
            }
        }
    }
    

    @IBAction func undoBarButtonPressed(_ sender: UIBarButtonItem) {
        let index = drawingCanvas.drawings.count - 1
        if index >= 0 {
            currentDrawing = nil
            drawingCanvas.currentDrawing = nil
            drawingCanvas.drawings.remove(at: index)
        }
    }
    
    @IBAction func clearBarButtonPressed(_ sender: UIBarButtonItem) {
        currentDrawing = nil
        drawingCanvas.currentDrawing = nil
        drawingCanvas.drawings = []
    }

    @IBAction func movedStrokeWidthSlider(_ sender: UISlider) {
        currentDrawing?.thickness = CGFloat(sender.value) * 20 + 1
    }
    
    @IBAction func toolBarButtonItemPresssed(_ sender: UIBarButtonItem) {
        if let color = sender.tintColor {
            self.color = color
        }
    }
    
    //https://developer.apple.com/documentation/uikit/1619125-uiimagewritetosavedphotosalbum
    @IBAction func saveBarButtonItemPressed(_ sender: UIBarButtonItem) {
        if !moreView.isHidden {
            moreView.isHidden = true
        }
        UIImageWriteToSavedPhotosAlbum(view.asImage(), nil, nil, nil);
    }
    
    @IBAction func moreBarButtonItemPressed(_ sender: UIBarButtonItem) {
        if moreView.isHidden {
            moreView.isHidden = false
            view.bringSubviewToFront(moreView)
        } else {
            moreView.isHidden = true
        }
    }
    
    @IBAction func animateButtonPressed(_ sender: UIButton) {
        if !moreView.isHidden {
            moreView.isHidden = true
        }

        UIView.animate(withDuration: 1, animations: {
            self.drawingCanvas.frame.origin.x -= 20
        }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                self.drawingCanvas.frame.origin.x += 40
            }, completion: { _ in
                UIView.animate(withDuration: 1, animations: {
                    self.drawingCanvas.frame.origin.x -= 20
                })
            })
        })
    }
    
    @IBAction func moveBrightnessSlider(_ sender: UISlider) {
        strokeAlpha = CGFloat(sender.value)
    }
    
    
}

//https://stackoverflow.com/questions/30696307/how-to-convert-a-uiview-to-an-image
extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
