//
//  MySetting.swift
//  Pods
//
//  Created by 张忠 on 2017/5/3.
//
//

import UIKit
import Appirater
import MessageUI
import StoreKit

public class MySetting: NSObject,MFMailComposeViewControllerDelegate {
    
    public static let shared : MySetting = {
        let instance = MySetting()
        return instance
    }()
    
    var startSectionIndex:Int = 0
    var baseController:UIViewController!
    var appID:String!
    var appName:String!
    var color = UIColor.orange
    var appArray = [MyApp]()
    var bundle:Bundle!
    
    public func config(startSec:Int, baseVC:UIViewController, appid:String, color:UIColor, appname:String?) {
        
        self.bundle = Bundle(for: MySetting.self as AnyClass)
        
        startSectionIndex = startSec
        baseController = baseVC
        appID = appid
        if let n = appname {
            appName = n
        }
        else {
            appName = ""
            let obj: AnyObject? = Bundle.main.infoDictionary!["CFBundleName"] as AnyObject?
            if let name = obj as? String {
                appName = name
            }
        }
        self.color = color
        
        Appirater.setAppId(appID)
        Appirater.setDaysUntilPrompt(7)
        Appirater.setUsesUntilPrompt(5)
        Appirater.setSignificantEventsUntilPrompt(-1)
        Appirater.setTimeBeforeReminding(3)
        Appirater.setDebug(false)
        Appirater.appLaunched(true)
    }
    
    public func startBackgroundLoad(appid:String) {
        self.appID = appid
        self.startLoadMoreApps {
            
        }
    }
    
    public func startLoadMoreApps(callback:@escaping (Void) -> Void){
        if appArray.count > 0 {
            return
        }
        let jsonPath = HomePath + appID + ".json"
        let jurl = URL(string: jsonPath)
        DispatchQueue.global().async {
            if let jdata = try? Data(contentsOf:jurl!) {
                if let dic = try! JSONSerialization.jsonObject(with: jdata, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:Any]{
                    if let ids = dic["apps"] as? [String] {
                        for id in ids {
                            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: nil)
                            let myapp = MyApp()
                            myapp.startLoad(appid: id, appcell: cell)
                            self.appArray.append(myapp)
                        }
                    }
                    callback()
                }
            }
        }

    }
    
    public func numberOfSettingSections() -> Int {
        return 2
    }
    
    public func numberOfRowsIn(section:Int) -> Int{
        let v = section - startSectionIndex
        if v == 0 {
            return 2
        }
        else if v == 1 {
            return appArray.count//more apps
        }
        else {
            return 0
        }
    }
    
    private func localizedString(_ str:String) -> String {
        let kLocalizedStringNotFound = "kLocalizedStringNotFound"
        var string = Bundle.main.localizedString(forKey: str, value: kLocalizedStringNotFound, table: "ZZLibLocalizable")
        if string == kLocalizedStringNotFound {
            string = bundle.localizedString(forKey: str, value: kLocalizedStringNotFound, table: "ZZLibLocalizable")
        }
        if string == kLocalizedStringNotFound {
            print("\(str) not localized")
            string = str
        }
        return string
    }

    
    //得到Cell
    public func cellFor(indexPath:IndexPath) -> UITableViewCell {
        let sec = indexPath.section - startSectionIndex
        let row = indexPath.row
        if sec == 0 {
            if row == 0 {
                let cell = UITableViewCell()

                cell.textLabel?.text = localizedString("Support ") + appName
                
                if let path = bundle.path(forResource: "support", ofType: "png") {
                    if let image = UIImage(contentsOfFile: path) {
                        cell.imageView?.image = self.color.paintImage(image)
                    }
                }

                cell.accessoryType = .disclosureIndicator
                return cell
            }
            else {
                let cell = UITableViewCell()
                cell.textLabel?.text = localizedString("Complain ") + appName
                if let path = bundle.path(forResource: "complain", ofType: "png") {
                    if let image = UIImage(contentsOfFile: path) {
                        cell.imageView?.image = self.color.paintImage(image)
                    }
                }
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            
        }
        else  {
            let myapp = appArray[row]
            return myapp.cell
        }
    }
    
    //点击事件
    public func clickedAt(indexPath:IndexPath,cell:UITableViewCell) {
        let sec = indexPath.section - startSectionIndex
        let row = indexPath.row
        if sec == 0 {
            if row == 0 {
                let alertController = UIAlertController(title: localizedString("Support ") + appName, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: localizedString("Cancel"), style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let rate = UIAlertAction(title: localizedString("Give 5 star review"), style: .default ) { (action) -> Void in
                    Appirater.rateApp()
                }
                alertController.addAction(rate)
                
                let share = UIAlertAction(title: localizedString("Recommend this app to friends"),style: .default ) { (action) -> Void in
                    self.shareApp()
                }
                alertController.addAction(share)
                
                let wx = UIAlertAction(title: localizedString("Connect WeChat Official Account"), style: .default ) { (action) -> Void in
                    self.contactWithWeixin()
                }
                alertController.addAction(wx)
                
                alertController.view.tintColor = color
                alertController.popoverPresentationController?.sourceView = cell
                alertController.popoverPresentationController?.sourceRect = cell.bounds
                baseController.present(alertController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: localizedString("Complain ") + appName, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: localizedString("Cancel"), style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let rate = UIAlertAction(title: localizedString("Complain by email"), style: .default ) { (action) -> Void in
                    self.emailFeedback()
                }
                alertController.addAction(rate)
                
                let share = UIAlertAction(title: localizedString("Connect WeChat Official Account"), style: .default ) { (action) -> Void in
                    self.contactWithWeixin()
                }
                alertController.addAction(share)
                
                alertController.view.tintColor = color
                alertController.popoverPresentationController?.sourceView = cell
                alertController.popoverPresentationController?.sourceRect = cell.bounds
                baseController.present(alertController, animated: true, completion: nil)
            }

        }
        else if sec == 1 {
            let app = appArray[row]
            let sv = SKStoreProductViewController()
            sv.delegate = self
            sv.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:app.id], completionBlock: { (_, err) in
                if err == nil {
                    self.baseController.present(sv, animated: true, completion: nil)
                }
            })
        }
    }
    
    public func heightFor(indexPath:IndexPath) -> CGFloat{
        let v = indexPath.section - startSectionIndex
        if v == 0 {
            return 44.0
        }
        else {
            return 50.0 //more apps
        }
    }
    
    public func titleFor(section:Int) -> String? {
        let v = section - startSectionIndex
        if v == 0 {
            return localizedString("Support")
        }
        else if v == 1 && appArray.count > 0{
            return localizedString("More apps") //more apps
        }
        return nil
    }
    
    fileprivate func shareApp(){
        let text = "\(appName) https://itunes.apple.com/app/id\(appID)"
        let items = [text]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.assignToContact]
        activityVC.popoverPresentationController?.sourceView = baseController.view
        activityVC.popoverPresentationController?.sourceRect = baseController.view.bounds
        baseController.present(activityVC, animated: true, completion: nil)
    }
    
    fileprivate func contactWithWeixin() {
        let name = "私房水果工具"
        UIPasteboard.general.string = name
        let av = UIAlertController(title: localizedString("Notice"), message: "在微信中关注订阅号 " + name + "，反馈问题和接收新消息。订阅号名称已复制到你的剪贴板中。", preferredStyle: .alert)
        let cancel = UIAlertAction(title: localizedString("Cancel"), style: .cancel, handler: nil)
        av.addAction(cancel)
        let done = UIAlertAction(title: localizedString("Open Weixin"), style: .default) { (_) in
            if let url = URL(string: "weixin://") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        }
        av.addAction(done)
        baseController.present(av, animated: true, completion: nil)
    }
    
    fileprivate func emailFeedback(){
        if MFMailComposeViewController.canSendMail(){
            let mvc = MFMailComposeViewController()
            mvc.mailComposeDelegate = self
            mvc.setSubject(localizedString("Feedback"))
            mvc.setToRecipients(["hellobanny@gmail.com"])
            var version = ""
            let vobj: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
            if let ver = vobj as? String{
                version = ver
            }
            let device = UIDevice.current
            let size = UIScreen.main.bounds.size
            mvc.setMessageBody("\n\n\n-----------------------------\n Name: \(appName!)\n Device: \(device.localizedModel) \n OS Version:\(device.systemVersion)\n App Version:\(version)\n Screen Size: \(size.width) * \(size.height)\n", isHTML: false)
            mvc.popoverPresentationController?.sourceView = baseController.view
            mvc.popoverPresentationController?.sourceRect = baseController.view.bounds
            baseController.present(mvc, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: localizedString("Notice"), message: localizedString("Your device doesn't support send email."), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: localizedString("OK"), style: .cancel) { (action) in
                print(action)
            }
            alertController.addAction(cancelAction)
            baseController.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismiss(animated: true, completion: nil)
    }
}

extension MySetting:SKStoreProductViewControllerDelegate{
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

