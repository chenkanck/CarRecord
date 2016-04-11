//
//  FileManager.swift
//  CarRecord
//
//  Created by Kan Chen on 4/5/16.
//  Copyright © 2016 kan. All rights reserved.
//

import Foundation

class FileManager {
    private let fm = NSFileManager.defaultManager()
    private func savingPath() -> String? {
        if let documentsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last {
            let videosDir = documentsDir.stringByAppendingString("/videos")
            var directory = ObjCBool(true)
            if !fm.fileExistsAtPath(videosDir, isDirectory: &directory) {
                do {
                    try fm.createDirectoryAtPath(videosDir, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print(error)
                    return nil
                }
            }
            return videosDir
            
        }
        return nil
    }
    
    
    func saveFileWithURL(contentURL: NSURL, complete: () -> Void) {
        guard let data = NSData(contentsOfURL: contentURL),
            videoDir = self.savingPath() else {
            complete()
            return
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm"
        let fileName = dateFormatter.stringFromDate(NSDate())
        let filePath = videoDir + "/" + fileName + ".mp4"
        if data.writeToFile(filePath, atomically: false) {
            complete()
        }
    }
}