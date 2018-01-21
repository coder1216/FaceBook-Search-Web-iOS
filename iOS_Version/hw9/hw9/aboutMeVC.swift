//
//  aboutMeVC.swift
//  final
//
//  Created by heng cui on 2017/4/26.
//  Copyright © 2017年 heng cui. All rights reserved.
//

import UIKit

class aboutMeVC: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        back.target = revealViewController()
        back.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
