//
//  OverlayViewController.swift
//  CarRecord
//
//  Created by Kan Chen on 4/3/16.
//  Copyright © 2016 kan. All rights reserved.
//

import UIKit

protocol OverlayDelegate {
    func overlayDidClickedLeftButton(overlayController: OverlayViewController)
    func overlayDidClickedStartOrStopButton(overlayController: OverlayViewController) -> Bool
}

class OverlayViewController: UIViewController {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var delegate: OverlayDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedRightButton(sender: AnyObject) {
        guard let start = delegate?.overlayDidClickedStartOrStopButton(self) else { return }
        if start {
            rightButton.setTitle("Stop", forState: .Normal)
        } else {
            rightButton.setTitle("Start", forState: .Normal)
        }
    }

    @IBAction func clickedLeftButton(sender: AnyObject) {
        delegate?.overlayDidClickedLeftButton(self)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
}
