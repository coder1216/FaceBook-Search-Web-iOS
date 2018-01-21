//
//  GroupPostTableView.swift
//  hw9
//
//  Created by Alex Hong on 4/25/17.
//  Copyright © 2017 Alex Hong. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKMessengerShareKit
var GroupPostJSon = Array<JSON>()
var groupId=""

class GroupPostTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBAction func groupPostShare(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        let favAction = UIAlertAction(title: "Remove from favorites", style: .default) { action in
            print("hello")
        }
        alertController.addAction(favAction)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) {
            action in
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "https://developers.facebook.com")! as URL
            FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        }
        alertController.addAction(shareAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("\(action)")
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            print("hello")
        }

    }
    
    
    
    @IBOutlet weak var groupPostTable: UITableView!

    override func viewDidLoad() {
        SwiftSpinner.show(duration: 4.0, title: "loading data...")
        super.viewDidLoad()
        print("ready to show grouppost")
        print(GroupPostJSon.count)
        
        groupPostTable.delegate = self
        groupPostTable.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if(groupId==""){
            return
        }
        print("http://cs-server.usc.edu:18487/index1.php?id=\(groupId)")
        Alamofire.request("http://cs-server.usc.edu:18487/index1.php?id=\(groupId)", method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print("yes or no")
                let obj = json["posts"]["data"]
                for i in 0..<obj.count{
                    GroupPostJSon.append(obj[i])
                }
                self.groupPostTable.reloadData()
                
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        
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
        if GroupPostJSon.count>0{
            return GroupPostJSon.count
        }
        return 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupPostCell", for: indexPath) as! DetailTableViewCell
        if GroupPostJSon.count==0{
            
            cell.postMessage.text="No data found"
            return cell
        }
        
        if let postmsg = GroupPostJSon[indexPath.row]["message"].string{
            print("here:\(postmsg)")
            cell.postMessage.text = postmsg
        }
        
        if let psttime = GroupPostJSon[indexPath.row]["created_time"].string{
            print("herepostttttt:\(psttime)")
            cell.postTime.text = psttime
            
        }
        
        
        if let postimg = GroupJSon[indexPath.row]["picture"]["data"]["url"].string{
            if let url = NSURL(string: postimg){
                if let imgData = NSData(contentsOf: url as URL){
                    cell.postImg.image=UIImage(data: imgData as Data)
                }
            }
            
        }

        // Configure the cell...
        SwiftSpinner.hide()
        return cell
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
