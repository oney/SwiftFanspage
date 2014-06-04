//
//  ViewController.swift
//  SwiftFanspage
//
//  Created by SpoonRocket on 2014/6/4.
//  Copyright (c) 2014年 oney. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    
    
    @IBOutlet var table: UITableView
    var search: UITextField = UITextField()
    @IBOutlet var activityIndicator: UIActivityIndicatorView
    
    let facebookToken = "CAAU9v7PfmyEBAMfjjR4wzzObEKZC1zmaZBn3l4fHN1BwQwEY4xIEqZCUJYKVAxWJyDPMIFfWGcXE6ZB154u2vxcdRb3C7ngXl8hZBp9AZBJSsuYmgGuwZAD1im7ZAD8hZAO80WtMYkKpGisib564xS1WYTtkc7V6eDfMgLRyNyZBDTiqa59dCeSu3KGVklLUStoHgZD"
    
    var tableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var searchView :UIView = UIView()
        searchView.frame = CGRectMake(0, 0, 270, 44)
        
        search.frame = CGRectMake(50, 7, 180, 30)
        search.layer.borderColor = UIColor.grayColor().CGColor!
        search.layer.borderWidth = 1.0
        search.layer.cornerRadius = 5.0
        search.delegate = self
        searchView.addSubview(search)
        
        var searchButton:UIButton = UIButton()
        
        searchButton.setTitleColor(UIColor.grayColor(), forState:UIControlState.Normal)
        searchButton.frame = CGRectMake(240, 0, 30, 44)
        searchButton.setTitle("Go", forState:UIControlState.Normal)
        searchButton.addTarget(self, action: Selector("searchClick:"), forControlEvents:UIControlEvents.TouchUpInside)
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
        
        var searchText = search.text
        if searchText == "" {
            searchText = "apple"
        }
        var string :NSString = "https://graph.facebook.com/search?q=\(searchText)&type=page&access_token=\(facebookToken)";
        var encodeString :NSString = string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url :NSURL = NSURL.URLWithString(encodeString)
        var request:NSURLRequest = NSURLRequest(URL:url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
            { (response :NSURLResponse!, data :NSData!, error :NSError!) in
                self.activityIndicator.stopAnimating()
                if error {
                    NSLog("error:%@", error.localizedDescription)
                }
                else {
                    var jsonString :NSString = NSString.init(data: data, encoding: NSUTF8StringEncoding)
                    NSLog("Response:%@", jsonString)
                    var jsonData :NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
                    var object : AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers, error: nil)
                    var dictionary :NSDictionary = object as NSDictionary
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
                }
            }
        )
    }
    
    
    func searchClick(button:UIButton) {
        searchFanspage()
        search.resignFirstResponder()
    }
    
    @IBAction func go(button:UIButton){
        NSLog("hiii")
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
    
}
