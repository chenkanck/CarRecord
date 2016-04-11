//
//  ViewController.swift
//  CarRecord
//
//  Created by Kan Chen on 3/20/16.
//  Copyright © 2016 kan. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, OverlayDelegate {
    @IBOutlet weak var containerView: UIView!
    var imagePickerController: UIImagePickerController!
    var overlayController: OverlayViewController!
    private var fileManager: FileManager!
    private var isRecording = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overlayController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("overlayController") as! OverlayViewController
        self.overlayController.delegate = self
        imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .Camera
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        imagePickerController.showsCameraControls = false
        imagePickerController.cameraOverlayView = overlayController.view
        imagePickerController.videoMaximumDuration = 300
        imagePickerController.delegate = self
        
        fileManager = FileManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func record(sender: AnyObject) {
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func overlayDidClickedLeftButton(overlayController: OverlayViewController) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func overlayDidClickedStartOrStopButton(overlayController: OverlayViewController) -> Bool {
        if !isRecording {
            isRecording = imagePickerController.startVideoCapture()
            return isRecording
        } else {
            imagePickerController.stopVideoCapture()
            return false
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            print(mediaType)
            if mediaType == kUTTypeMovie as String {
                if let url = info[UIImagePickerControllerMediaURL] as? NSURL,
                    path = url.path {
                    fileManager.saveFileWithURL(url, complete: { 
                        print("Saved \(path)")
                    })
                    UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
                }
            }
        }
        
    }
}
