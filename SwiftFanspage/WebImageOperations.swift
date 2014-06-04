//
//  WebImageOperations.swift
//  SwiftFanspage
//
//  Created by Oney on 2014/6/4.
//  Copyright (c) 2014 oney. All rights reserved.
//

import UIKit

class WebImageOperations: NSObject {
    class func processImageDataWithURLString(urlString :NSString, handler:((NSData!) -> Void)!) {
        var url :NSURL = NSURL.URLWithString(urlString)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var imageData:NSData = NSData.dataWithContentsOfURL(url, options: .DataReadingMappedIfSafe, error: nil)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                handler(imageData)
            }
        }
    }

}
