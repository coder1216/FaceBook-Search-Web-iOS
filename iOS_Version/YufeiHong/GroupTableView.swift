//
//  GroupTableView.swift
//  hw9
//
//  Created by Alex Hong on 4/24/17.
//  Copyright © 2017 Alex Hong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
var GroupJSon = Array<JSON>()
var groupNextData = ""
var groupPreviousData = ""

class GroupTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var groupTbView: UITableView!
    override func viewDidLoad() {
        SwiftSpinner.show(duration: 4.0, title: "loading data...")
        super.viewDidLoad()
        groupTbView.dataSource = self
        groupTbView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if(key==""){
            return
        }
        Alamofire.request("http://cs-server.usc.edu:18487/index1.php?key=\(key)&type=group", method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    GroupJSon.append(obj[i])
                }
                self.groupTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    groupNextData = nextUrl
                    print(nextUrl)
                }
                
                if let preUrl = json["paging"]["previous"].string{
                    groupPreviousData = preUrl
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
        if GroupJSon.count>0{
            return GroupJSon.count
        }

        return 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! ResultTableViewCell
        if GroupJSon.count==0{
            cell.userName.text="nil"
            return cell
        }
        
        if let gname = GroupJSon[indexPath.row]["name"].string{
            print("here:\(gname)")
            cell.userName.text = gname
        }
        
        if let gimg = GroupJSon[indexPath.row]["picture"]["data"]["url"].string{
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
        if let myid=GroupJSon[indexPath.row]["id"].string{
            groupId=myid
            print(groupId)
        }
    }
    
    @IBAction func GroupBackControl(segue: UIStoryboardSegue) {
    }
    
    
    @IBAction func groupPrev(_ sender: UIButton) {
        if(groupPreviousData==""){
            return
        }
        
        GroupJSon.removeAll()
        
        Alamofire.request(groupPreviousData, method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    GroupJSon.append(obj[i])
                    
                }
                self.groupTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    groupNextData = nextUrl
                    print(nextUrl)
                }
                if let preUrl = json["paging"]["previous"].string{
                    groupPreviousData = preUrl
                    print(preUrl)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }

    }
    
    
    @IBAction func groupNext(_ sender: UIButton) {
        if(pageNextData==""){
            return
        }
        GroupJSon.removeAll()
        Alamofire.request(pageNextData, method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    GroupJSon.append(obj[i])
                    
                }
                self.groupTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    groupNextData = nextUrl
                    print(nextUrl)
                }
                if let preUrl = json["paging"]["previous"].string{
                    groupPreviousData = preUrl
                    print(preUrl)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
