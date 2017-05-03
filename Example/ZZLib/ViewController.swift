//
//  ViewController.swift
//  ZZLib
//
//  Created by 张忠 on 05/03/2017.
//  Copyright (c) 2017 张忠. All rights reserved.
//

import UIKit
import ZZLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let h = Hello()
        h.sayHi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

