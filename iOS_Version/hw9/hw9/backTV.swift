//
//  backTV.swift
//  
//
//  Created by heng cui on 2017/4/26.
//
//

import UIKit

class backTV: UITableViewController {
    let iconArray:Array = [#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "favorite")]
    let nameArray:Array = ["Home", "Favorite"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 2
        }else{
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "backCell", for: indexPath) as! backCell
        if indexPath.section == 0{
            cell.name.text! = "FB Search"
            cell.icon.image = #imageLiteral(resourceName: "fb")
        }else if indexPath.section == 1{
            cell.name.text! = nameArray[indexPath.row]
            cell.icon.image = iconArray[indexPath.row]
        }else{
            cell.name.text! = "About Me"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return nil
        }else if section == 1{
            return "MENU"
        }else{
            return "OTHERS"
        }
    }
    
    @IBAction func PageAllBackControl(segue: UIStoryboardSegue) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:backCell = tableView.cellForRow(at: indexPath) as! backCell
        print(cell.name.text!)
        if cell.name.text! == "Home"{
            let mainstoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "Main") as! ViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            revealcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.name.text! == "Favorite"{
            let mainstoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "Favorite") as! UITableViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            revealcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.name.text! == "About Me"{
            let mainstoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "AboutMe")
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            revealcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        
    }
}


