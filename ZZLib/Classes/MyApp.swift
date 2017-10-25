//
//  MyApp.swift
//  Pods
//
//  Created by 张忠 on 2017/5/5.
//
//

import UIKit

let HomePath = "http://appby.us/myapps/"

class MyApp: NSObject {
    var id:String!
    var title:String?
    var detail:String?
    var image:UIImage?
    
    func loadMoreInfo(appid:String){
        self.id = appid
        var isCn = false
        if let str = NSLocale.preferredLanguages.first {
            if str == "zh-Hans-CN" {
                isCn = true
            }
        }
        let jsonPath = HomePath + appid + ".json"
        let jurl = URL(string: jsonPath)
        if let jdata = try? Data(contentsOf:jurl!) {
            if let dic = try! JSONSerialization.jsonObject(with: jdata, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:Any]{
                if isCn {
                    self.title = dic["title-cn"] as? String
                    self.detail = dic["detail-cn"] as? String
                }
                else {
                    self.title = dic["title"] as? String
                    self.detail = dic["detail"] as? String
                }
            }
        }
        let picPath = HomePath + appid + ".png"
        let url = URL(string: picPath)
        if let data = try? Data(contentsOf: url!) {
            self.image = UIImage(data:data)
        }
    }
}
