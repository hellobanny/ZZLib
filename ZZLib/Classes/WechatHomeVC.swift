//
//  WechatHomeVC.swift
//  redbox
//
//  Created by 张忠 on 2019/11/19.
//  Copyright © 2019 张忠. All rights reserved.
//

import UIKit

class WechatHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WechatHomeVC.shareImage))
    }

    @objc func shareImage(){
        if let img = UIImage(named: "wechatgzh") {
            let items = [img]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.assignToContact]
            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
}
