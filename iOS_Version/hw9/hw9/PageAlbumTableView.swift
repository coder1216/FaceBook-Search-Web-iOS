//
//  PageAlbumTableView.swift
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


var PageAlbumJSon = Array<JSON>()


class PageAlbumTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var pictureUrl = ""
   
//fb share
    @IBAction func pageAlbumShare(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        let favAction = UIAlertAction(title: "Remove from favorites", style: .default) { action in
            print("hello")
        }
        alertController.addAction(favAction)
        
        
        let shareAction = UIAlertAction(title: "Share", style: .default) {
            action in
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: self.pictureUrl)! as URL
            FBSDKShareDialog.show(from: self, with: content, delegate: nil)
            
        }
        alertController.addAction(shareAction)
        self.view.showToast("Cannot be empty", position: .bottom, popTime:1, dismissOnTap: false)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("\(action)")
            
        }
        
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true) {
            print("hello")
        }
    }
    
    
    
    
    @IBOutlet weak var pageAlbumTable: UITableView!
    
    
    override func viewDidLoad() {
        SwiftSpinner.show(duration: 4.0, title: "loading data...")
        super.viewDidLoad()
        
        
        pageAlbumTable.delegate=self
        pageAlbumTable.dataSource=self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if(pageId==""){
            return
        }
        
        print("http://cs-server.usc.edu:18487/index1.php?id=\(pageId)")
        
        PageAlbumJSon.removeAll()
        Alamofire.request("http://cs-server.usc.edu:18487/index1.php?id=\(pageId)", method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)

                
                
                let obj = json["albums"]["data"]
                for i in 0..<obj.count{
                    PageAlbumJSon.append(obj[i])
                }
                self.pageAlbumTable.reloadData()
                self.pictureUrl = json["picture"]["data"]["url"].string!
                
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
        if PageAlbumJSon.count>0{
            return PageAlbumJSon.count
        }
        return 1
    }
    
//Toggle details
    
    var selectedIndexPath : IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
       } else {
            selectedIndexPath = indexPath
       }
        
       var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumTableCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumTableCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return AlbumTableCell.expandedHeight
        } else {
            return AlbumTableCell.defaultHeight
        }
    }

    
//show table
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pageAlbumCell", for: indexPath) as! AlbumTableCell
        if PageAlbumJSon.count == 0{
            print("last cell")
            cell.albumNameCell.text="No data found"
            return cell
        }

        if let albumNameCell = PageAlbumJSon[indexPath.row]["name"].string{
                cell.albumNameCell.text = albumNameCell
            }
        
        if let albumPicCell1 = PageAlbumJSon[indexPath.row]["photos"]["data"][0]["picture"].string{
            if let url = NSURL(string: albumPicCell1){
                if let imgData = NSData(contentsOf: url as URL){
                    cell.albumPicCell1.image=UIImage(data: imgData as Data)
                }
            }
        }
        
        if let albumPicCell2 = PageAlbumJSon[indexPath.row]["photos"]["data"][1]["picture"].string{
            if let url = NSURL(string: albumPicCell2){
                if let imgData = NSData(contentsOf: url as URL){
                    cell.albumPicCell2.image=UIImage(data: imgData as Data)
                }
            }
        }
        
    SwiftSpinner.hide()
    return cell

        
        
        
        
        
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
}
