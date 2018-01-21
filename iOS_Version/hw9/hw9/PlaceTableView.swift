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
import MapKit
var PlaceJSon = Array<JSON>()
var latitude = 37.785834
var longitude = -122.406417

var placeNextData = ""
var placePreviousData = ""

class PlaceTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet weak var placeTbView: UITableView!
    
    override func viewDidLoad() {
        SwiftSpinner.show(duration: 4.0, title: "loading data...")
        super.viewDidLoad()
        
        placeTbView.delegate = self
        placeTbView.dataSource = self
        
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            latitude=currentLocation.coordinate.latitude
            longitude=currentLocation.coordinate.longitude
        }
        
        print("ready to show event")
        print(PlaceJSon.count)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if(key==""){
            return
        }
        PlaceJSon.removeAll()
        Alamofire.request("http://cs-server.usc.edu:18487/index1.php?key=\(key)&type=place&lat=\(latitude)&lon=\(longitude)", method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    PlaceJSon.append(obj[i])
                }
                self.placeTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    placeNextData = nextUrl
                    print(nextUrl)
                }
                
                if let preUrl = json["paging"]["previous"].string{
                    placePreviousData = preUrl
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
        if PlaceJSon.count>0{
            return PlaceJSon.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! ResultTableViewCell
        if PlaceJSon.count==0{
            
            cell.userName.text="nil"
            return cell
        }
        if let gname = PlaceJSon[indexPath.row]["name"].string{
            print("here:\(gname)")
            cell.userName.text = gname
        }
        if let gimg = PlaceJSon[indexPath.row]["picture"]["data"]["url"].string{
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
        if let myid=PlaceJSon[indexPath.row]["id"].string{
            placeId=myid
            print(placeId)
        }
    }
    
    @IBAction func PlaceBackControl(segue: UIStoryboardSegue) {
    }

    

    @IBAction func placePrev(_ sender: UIButton) {
        if(placePreviousData==""){
            return
        }
        print("im here!!!")
        PlaceJSon.removeAll()
        
        Alamofire.request(placePreviousData, method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    PlaceJSon.append(obj[i])
                    
                }
                self.placeTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    placeNextData = nextUrl
                    
                }
                
                if let preUrl = json["paging"]["previous"].string{
                    placePreviousData = preUrl
                    
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }

    }
    
    
    @IBAction func placeNext(_ sender: UIButton) {
        if(placeNextData==""){
            return
        }
        PlaceJSon.removeAll()
        Alamofire.request(placeNextData, method: .get).validate().responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let obj = json["data"]
                for i in 0..<obj.count{
                    PlaceJSon.append(obj[i])
                    
                }
                self.placeTbView.reloadData()
                
                if let nextUrl = json["paging"]["next"].string{
                    placeNextData = nextUrl
                    print(nextUrl)
                }
                if let preUrl = json["paging"]["previous"].string{
                    placePreviousData = preUrl
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
