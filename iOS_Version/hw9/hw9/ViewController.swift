//
//  ViewController.swift
//  hw9
//
//  Created by Alex Hong on 4/23/17.
//  Copyright © 2017 Alex Hong. All rights reserved.
//

import UIKit

var key:String = ""

class ViewController: UIViewController{

    @IBOutlet weak var Menu: UIBarButtonItem!
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBAction func SearchBtn(_ sender: UIButton) {
        if(TextField.text == ""){
            self.view.showToast("Cannot be empty", position: .bottom, popTime:1, dismissOnTap: false)
            
        }
         key = TextField.text!
    }
    
    @IBAction func ClearBtn(_ sender: UIButton) {
        TextField.text = ""
    }
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Menu.target = self.revealViewController()
        Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    


}

