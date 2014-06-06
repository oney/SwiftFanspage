//
//  FanspageDetailViewController.swift
//  SwiftFanspage
//
//  Created by SpoonRocket on 2014/6/6.
//  Copyright (c) 2014年 oney. All rights reserved.
//

import UIKit

class FanspageDetailViewController: UIViewController {

    @IBOutlet var webView :UIWebView
    var segueParam :NSDictionary!
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("segueParam:%@", segueParam)
        var fid :AnyObject = segueParam["id"]
        var url = "https://www.facebook.com/\(fid)"
        webView.loadRequest(NSURLRequest(URL:NSURL.URLWithString(url)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
