//
//  EventTableView.swift
//  hw9
//
//  Created by Alex Hong on 4/25/17.
//  Copyright © 2017 Alex Hong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
var EventJSon = Array<JSON>()
var eventNextData = ""
var eventPreviousData = ""

class EventTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var eventTbView: UITableView!
    
    override func viewDidLoad() {
        SwiftSpinner.show(duration: 4.0, title: "loading data...")
        super.viewDidLoad()
        
        print("ready to show event")
        print(EventJSon.count)

        eventTbView.dataSource = self
        eventTbView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if(key==""){
            return
        }
        EventJSon.removeAll()
        Alamofire.request("http://cs-server.usc.edu:18487/index1.php?key=\(key)&type=event", method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                
                let json = JSON(value)
                
                let obj = json["data"]
                for i in 0..<obj.count{
                    EventJSon.append(obj[i])
                }
                self.eventTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    eventNextData = nextUrl
                    print(nextUrl)
                }
                
                if let preUrl = json["paging"]["previous"].string{
                    eventPreviousData = preUrl
                    print(preUrl)
                }

                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if EventJSon.count>0{
            return EventJSon.count
        }
        return 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ResultTableViewCell
        if EventJSon.count==0{
            
            cell.userName.text="nil"
            return cell
        }
        if let gname = EventJSon[indexPath.row]["name"].string{
            print("here:\(gname)")
            cell.userName.text = gname
        }
        if let gimg = EventJSon[indexPath.row]["picture"]["data"]["url"].string{
            if let url = NSURL(string: gimg){
                if let imgData = NSData(contentsOf: url as URL){
                    cell.userImag.image=UIImage(data: imgData as Data)
                }
            }
            
        }
        // Configure the cell...
        SwiftSpinner.hide()
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let myid = EventJSon[indexPath.row]["id"].string{
            eventId = myid
            print(eventId)
        }
    }

    @IBAction func EventBackControl(segue: UIStoryboardSegue) {
    }
    
    
    @IBAction func eventPrev(_ sender: UIButton) {
        if(eventPreviousData==""){
            return
        }
        
        EventJSon.removeAll()
        
        Alamofire.request(eventPreviousData, method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    EventJSon.append(obj[i])
                    
                }
                self.eventTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    eventNextData = nextUrl
                    print(nextUrl)
                }
                if let preUrl = json["paging"]["previous"].string{
                    eventPreviousData = preUrl
                    print(preUrl)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }

    }
    
    
    @IBAction func eventNext(_ sender: UIButton) {
        if(pageNextData==""){
            return
        }
        EventJSon.removeAll()
        
        Alamofire.request(eventNextData, method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    EventJSon.append(obj[i])
                    
                }
                self.eventTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    eventNextData = nextUrl
                    print(nextUrl)
                }
                if let preUrl = json["paging"]["previous"].string{
                    eventPreviousData = preUrl
                    print(preUrl)
                }
                
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
