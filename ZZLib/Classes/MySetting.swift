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
        
        let bundles = Bundle.allBundles
        for bd in bundles {
            print(bd.bundlePath)
        }
        if let url = Bundle.main.url(forResource: "ZZLib", withExtension: "bundle") {
            self.bundle = Bundle(url: url)!
        }
        else {
            self.bundle = Bundle.main
        }
        self.bundle = Bundle.init(for: MySetting.classForCoder())
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
    
    //得到Cell
    public func cellFor(indexPath:IndexPath) -> UITableViewCell {
        let sec = indexPath.section - startSectionIndex
        let row = indexPath.row
        if sec == 0 {
            if row == 0 {
                let cell = UITableViewCell()

                cell.textLabel?.text = NSLocalizedString("Support ",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"") + appName
                
                cell.imageView?.image = UIImage(named: "support", in: self.bundle, compatibleWith: nil)
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            else {
                let cell = UITableViewCell()
                cell.textLabel?.text = NSLocalizedString("Complain ",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"") + appName
                let bundle = Bundle(for: MySetting.self as AnyClass)
                
                if let path = bundle.path(forResource: "complain", ofType: "pdf") {
                    if let image = UIImage(contentsOfFile: path) {
                        cell.imageView?.image = image
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
                let alertController = UIAlertController(title: NSLocalizedString("Support ",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"") + appName, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let rate = UIAlertAction(title: NSLocalizedString("Give 5 star review",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), style: .default ) { (action) -> Void in
                    Appirater.rateApp()
                }
                alertController.addAction(rate)
                
                let share = UIAlertAction(title: NSLocalizedString("Recommend this app to friends",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), style: .default ) { (action) -> Void in
                    self.shareApp()
                }
                
                alertController.addAction(share)
                
                alertController.view.tintColor = color
                alertController.popoverPresentationController?.sourceView = cell
                alertController.popoverPresentationController?.sourceRect = cell.bounds
                baseController.present(alertController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: NSLocalizedString("Complain ",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"") + appName, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let rate = UIAlertAction(title: NSLocalizedString("Complain by email",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), style: .default ) { (action) -> Void in
                    self.emailFeedback()
                }
                alertController.addAction(rate)
                
                let share = UIAlertAction(title: NSLocalizedString("Contact with weixin",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), style: .default ) { (action) -> Void in
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
            return NSLocalizedString("Support",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"")
        }
        else if v == 1 && appArray.count > 0{
            return NSLocalizedString("More apps",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"") //more apps
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
        UIPasteboard.general.string = "hellobanny"
        let av = UIAlertController(title: NSLocalizedString("Notice",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"Notice"), message: NSLocalizedString("Add hellobanny in weixin and start a chat. The user name has add to your paste board.",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"Cancel"), style: .cancel, handler: nil)
        av.addAction(cancel)
        let done = UIAlertAction(title: NSLocalizedString("Open Weixin",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"Open Weixin"), style: .default) { (_) in
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
            mvc.setSubject(NSLocalizedString("Feedback",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"Feedback"))
            mvc.setToRecipients(["hellobanny@gmail.com"])
            var version = ""
            let vobj: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
            if let ver = vobj as? String{
                version = ver
            }
            let device = UIDevice.current
            let size = UIScreen.main.bounds.size
            mvc.setMessageBody("\n\n\n-----------------------------\n Name: \(appName)\n Device: \(device.localizedModel) \n OS Version:\(device.systemVersion)\n App Version:\(version)\n Screen:\(size.width)*\(size.height)\n", isHTML: false)
            mvc.popoverPresentationController?.sourceView = baseController.view
            mvc.popoverPresentationController?.sourceRect = baseController.view.bounds
            baseController.present(mvc, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: NSLocalizedString("Notice",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"Notice"), message: NSLocalizedString("Your device doesn't support send email.",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:""), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("OK",tableName:"ZZLibLocalizable",bundle: self.bundle,comment:"OK"), style: .cancel) { (action) in
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

