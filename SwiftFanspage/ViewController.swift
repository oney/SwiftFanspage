//
//  ViewController.swift
//  SwiftFanspage
//
//  Created by Oney on 2014/6/4.
//  Copyright (c) 2014 oney. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    
    
    @IBOutlet var table: UITableView
    var search: UITextField = UITextField()
    var searchView :UIView = UIView()
    @IBOutlet var activityIndicator: UIActivityIndicatorView
    
    let facebookToken :NSString = "CAAU9v7PfmyEBAOrTTI1zplN1LlBPPkZCVKvwqeKVLvlLOu5qG5aA5nbYZCv6z52U8Ad17NnPh8FwSAtzlwguAcsUsblToJJ1MPZB375nnGnLfy8s6jOtOTKAmhqRcxrZCqZCeSCZASQzv5qnpBIZBh6NDFBNoLJTBIi8yguiVOO58ncTN34ViCN" //Replace token if it has expired, you can get the token in https://developers.facebook.com/tools/explorer/
    
    var tableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.frame = CGRectMake(0, 0, 270, 44)
        
        search.frame = CGRectMake(50, 7, 180, 30)
        search.layer.borderColor = UIColor.grayColor().CGColor!
        search.layer.borderWidth = 1.0
        search.layer.cornerRadius = 5.0
        search.delegate = self
        searchView.addSubview(search)
        
        var searchButton:UIButton = UIButton()
        
        searchButton.setTitleColor(UIColor.grayColor(), forState:.Normal)
        searchButton.frame = CGRectMake(240, 0, 30, 44)
        searchButton.setTitle("Go", forState:.Normal)
        searchButton.addTarget(self, action: Selector("searchClick:"), forControlEvents:.TouchUpInside)
        searchView.addSubview(searchButton)
        
        self.navigationController.navigationBar.addSubview(searchView)
        
        searchFanspage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchFanspage() {
        self.activityIndicator.startAnimating()
        
        var searchText :NSString = search.text
        if searchText == "" {
            searchText = "apple"
        }
        

        
        var string :NSString = "https://graph.facebook.com/search?q=\(searchText)&type=page&access_token=\(facebookToken)";
        var params :NSMutableDictionary = NSMutableDictionary()
        
        API.sharedInstance.getPath(string, params: params, completion:
            {(response :NSURLResponse!, json :AnyObject!) in
                self.activityIndicator.stopAnimating()
                
                var dictionary :NSDictionary = json as NSDictionary
                if dictionary["error"] {
                    NSLog("error:%@", (dictionary["error"] as NSDictionary)["message"] as NSString)
                    var path :NSString = NSBundle.mainBundle().pathForResource("facebook", ofType: "txt")
                    var content :NSString = NSString.stringWithContentsOfFile(path, encoding:NSUTF8StringEncoding, error:nil)
                    NSLog("content:%@", content)
                    var jsonData :NSData = content.dataUsingEncoding(NSUTF8StringEncoding)
                    var object : AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers, error: nil)
                    dictionary = object as NSDictionary
                }
                
                self.tableArray = dictionary["data"] as NSArray
                self.table.reloadData()
            
        }, failure: {(response :NSURLResponse!, error :NSError!) in
            NSLog("error:%@", error.localizedDescription)
        })
    }
    
    
    func searchClick(button:UIButton) {
        searchFanspage()
//        search.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell: FanspageCell = tableView.dequeueReusableCellWithIdentifier("FanspageCellIdentifier") as FanspageCell
        var object :NSMutableDictionary = self.tableArray[indexPath.row] as NSMutableDictionary
        var name : String = object["name"] as String
        var category : String = object["category"] as String
        var uid : String = object["id"] as String
        var photoUrlString = "https://graph.facebook.com/\(uid)/picture"
        cell.name.text = "Name: \(name)"
        cell.category.text = category
        cell.photo.image = nil
        
/*
        cell.photo.setImageWithURL(NSURL.URLWithString(photoUrlString))
        var url :NSURL = NSURL.URLWithString(photoUrlString)
        var manager :SDWebImageManager = SDWebImageManager.sharedManager()
        manager.downloadWithURL(url, options: SDWebImageOptions.CacheMemoryOnly, progress:nil , completed: {(image :UIImage!, error :NSError!, cacheType :SDImageCacheType, finished:Bool) in
            if image {
                cell.photo.image = image
            }
            
            
            }
        )
*/
        
        WebImageOperations.processImageDataWithURLString(photoUrlString,
            { (data :NSData!) in
                var image :UIImage = UIImage(data: data)
                cell.photo.image = image
            }
        )
        
        return cell
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        searchFanspage()
        textField.resignFirstResponder()
        return true
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        searchView.hidden = true
        var dic :NSDictionary = self.tableArray[indexPath.row] as NSDictionary
        self.performSegueWithIdentifier("fanspageDetail", sender: dic)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue?.identifier == "fanspageDetail" {
            var dest :FanspageDetailViewController = segue?.destinationViewController as FanspageDetailViewController
            var dic :NSDictionary = sender as NSDictionary
            dest.segueParam = dic
        }
        
        
    }
    
}
