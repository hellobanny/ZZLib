//
//  ViewController.swift
//  ZZLib
//
//  Created by 张忠 on 05/03/2017.
//  Copyright (c) 2017 张忠. All rights reserved.
//

import UIKit
import ZZLib
import Localize_Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MySetting.shared.startBackgroundLoad(appid: "1051212505")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func test2(_ sender: Any) {
        let thtc = TestHomeTC(style: .grouped)
        let nav = UINavigationController(rootViewController: thtc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func changeLanguage(_ sender: Any) {
        let langs = Localize.availableLanguages(true)
        let alertController = UIAlertController(title: "Switch Language".localized(), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        for lan in langs {
            let edit = UIAlertAction(title: Localize.displayNameForLanguage(lan) , style: .default ) { (action) -> Void in
                Localize.setCurrentLanguage(lan)
                ZZSetting.shared.changeLanguage(lan: lan)
            }
            alertController.addAction(edit)
        }
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
}

