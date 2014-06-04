//
//  API.swift
//  SwiftFanspage
//
//  Created by SpoonRocket on 2014/6/5.
//  Copyright (c) 2014年 oney. All rights reserved.
//

import UIKit

class API: NSObject {
    class var sharedInstance:API {
        get {
            struct Static {
                static var instance : API? = nil
                static var token : dispatch_once_t = 0
            }
            dispatch_once(&Static.token) { Static.instance = API() }
            return Static.instance!
        }
    }
    init() {
        super.init()
    }
    func getPath(path :NSString, params :NSDictionary, completion:((NSURLResponse!, AnyObject!) -> Void)!, failure:((NSURLResponse!, NSError!) -> Void)!) -> Void {
        

        var encodeString :NSString = path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url :NSURL = NSURL.URLWithString(encodeString)
        var request:NSURLRequest = NSURLRequest(URL:url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
            { (response :NSURLResponse!, data :NSData!, error :NSError!) in
                if error {
                    failure(response, error)
                }
                else {
                    var jsonString :NSString = NSString.init(data: data, encoding: NSUTF8StringEncoding)
                    var jsonData :NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
                    var jsonError :NSErrorPointer = nil
                    var object : AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers, error: jsonError)
                    var dictionary :NSDictionary = object as NSDictionary
                    if jsonError {
                        failure(response, error)
                    }
                    else {
                        completion(response, object)
                    }
                }
            }
        )
    }
}
