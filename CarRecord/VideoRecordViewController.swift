//
//  VideoRecordViewController.swift
//  CarRecord
//
//  Created by Kan Chen on 4/17/16.
//  Copyright © 2016 kan. All rights reserved.
//

import UIKit

class VideoRecordViewController: UIViewController {
    var camera: LLSimpleCamera!
    private var fileManager = FileManager()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var errorLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        initCamera()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        camera.start()
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(recordButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initCamera() {
        camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        let cameraFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
        camera.attachToViewController(self, withFrame: cameraFrame)
        camera.fixOrientationAfterCapture = false
        
        camera.onDeviceChange = { camera, device in
            print("Device changed")
        }
        
        camera.onError = {[weak self] camera, error  in
            if error.domain == LLSimpleCameraErrorDomain {
                if error.code == Int(LLSimpleCameraErrorCodeCameraPermission.rawValue) || error.code == Int(LLSimpleCameraErrorCodeMicrophonePermission.rawValue) {
                    guard let strongSelf = self else { return }
                    if let label = strongSelf.errorLabel { label.removeFromSuperview() }
                    let label = UILabel(frame: CGRectZero)
                    label.text = "We need permission for the camera.\nPlease go to your settings."
                    label.numberOfLines = 2
                    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    label.backgroundColor = UIColor.clearColor()
                    label.textColor = UIColor.whiteColor()
                    label.textAlignment = NSTextAlignment.Center
                    label.sizeToFit()
                    label.center = CGPoint(x: cameraFrame.size.width / 2, y: cameraFrame.size.height / 2)
                    strongSelf.errorLabel = label
                    strongSelf.view.addSubview(label)
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func clickedCloseButton(sender: AnyObject) {
        camera.stop()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickedRecordButton(sender: AnyObject) {
        if !camera.recording {
            recordButton.setTitle("Stop", forState: .Normal)
                        camera.startRecordingWithOutputUrl(NSURL(fileURLWithPath: newFileUrl))
        } else {
            recordButton.setTitle("Start", forState: .Normal)
            camera.stopRecording({ (camera, outputFileUrl, error) in
            })
        }
    }
    //MARK: -
    private var newFileUrl: String {
        guard let url = fileManager.videoDirectoryUrl else { fatalError() }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm"
        let fileName = dateFormatter.stringFromDate(NSDate())
        return url + "/" + fileName + ".mp4"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        camera.view.frame = view.contentBounds
        
    }
}
