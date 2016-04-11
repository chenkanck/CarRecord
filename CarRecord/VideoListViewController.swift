//
//  VideoListViewController.swift
//  CarRecord
//
//  Created by Kan Chen on 4/10/16.
//  Copyright © 2016 kan. All rights reserved.
//

import UIKit

class VideoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var videoPaths = [String]()
    private let fileManager = FileManager()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        videoPaths = fileManager.getVideoList()
    }
    
    @IBAction func clickedBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoPaths.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = videoPaths[indexPath.row]
        return cell
    }
    
    
}
