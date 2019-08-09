//
//  ZZHomeTC.swift
//  ZZLib
//
//  Created by 张忠 on 2019/1/8.
//

import UIKit
import Appirater
import MessageUI
import StoreKit
import Localize_Swift

public class ZZSetting: NSObject,MFMailComposeViewControllerDelegate {
    
    public static let shared : ZZSetting = {
        let instance = ZZSetting()
        return instance
    }()
    
    var startSectionIndex:Int = 0
    var baseController:UIViewController!
    var appID:String = ""
    var appName:String = ""
    var color = UIColor.orange
    var moreApps = [ZZApp]()
    var bundle:Bundle!
    
    override init() {
        self.bundle = Bundle(for: ZZSetting.self as AnyClass)
    }
    
    public func config(startSec:Int, baseVC:UIViewController, appid:String, color:UIColor, appname:String?, moreApps:[ZZApp]) {
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
        self.moreApps = moreApps
        
        Appirater.setAppId(appID)
        Appirater.setDaysUntilPrompt(7)
        Appirater.setUsesUntilPrompt(5)
        Appirater.setSignificantEventsUntilPrompt(-1)
        Appirater.setTimeBeforeReminding(3)
        Appirater.setDebug(false)
        Appirater.appLaunched(true)
    }
    
    public func changeLanguage(lan:String){
        Localize.setCurrentLanguage(lan)
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
            return moreApps.count
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
                
                cell.textLabel?.text = "Support ".zzLocal() + appName
                
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
                cell.textLabel?.text = "Complain ".zzLocal() + appName
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
            let myapp = moreApps[row]
            let nib = bundle.loadNibNamed("ZZAppCell", owner: self, options: nil)
            let cell = nib?.first! as! ZZAppCell
            cell.configWith(app: myapp, bundle: bundle)
            return cell
        }
    }
    
    //点击事件
    public func clickedAt(indexPath:IndexPath,cell:UITableViewCell) {
        let sec = indexPath.section - startSectionIndex
        let row = indexPath.row
        if sec == 0 {
            if row == 0 {
                let alertController = UIAlertController(title: "Support ".zzLocal() + appName, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel".zzLocal(), style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let rate = UIAlertAction(title: "Rate App".zzLocal(), style: .default ) { (action) -> Void in
                    Appirater.rateApp()
                }
                alertController.addAction(rate)
                
                let share = UIAlertAction(title: "Recommend this app to friends".zzLocal(),style: .default ) { (action) -> Void in
                    self.shareApp()
                }
                alertController.addAction(share)
                
                let wx = UIAlertAction(title: "Connect WeChat Official Account".zzLocal(), style: .default ) { (action) -> Void in
                    self.contactWithWeixin()
                }
                alertController.addAction(wx)
                
                alertController.view.tintColor = color
                alertController.popoverPresentationController?.sourceView = cell
                alertController.popoverPresentationController?.sourceRect = cell.bounds
                baseController.present(alertController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Complain ".zzLocal() + appName, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel".zzLocal(), style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let rate = UIAlertAction(title: "Complain by email".zzLocal(), style: .default ) { (action) -> Void in
                    self.emailFeedback()
                }
                alertController.addAction(rate)
                
                let share = UIAlertAction(title: "Connect WeChat Official Account".zzLocal(), style: .default ) { (action) -> Void in
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
            let app = moreApps[row]
            let sv = SKStoreProductViewController()
            sv.delegate = self
            sv.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:app.appId()], completionBlock: { (_, err) in
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
            return "Support".zzLocal()
        }
        else if v == 1 && moreApps.count > 0{
            return "More apps".zzLocal() //more apps
        }
        return nil
    }
    
    fileprivate func shareApp(){
        let text = "\(appName) https://itunes.apple.com/app/id\(appID)"
        let items = [text]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.assignToContact]
        activityVC.popoverPresentationController?.sourceView = baseController.view
        activityVC.popoverPresentationController?.sourceRect = baseController.view.bounds
        baseController.present(activityVC, animated: true, completion: nil)
    }
    
    fileprivate func contactWithWeixin() {
        let name = "私房水果工具"
        UIPasteboard.general.string = name
        let av = UIAlertController(title: "Notice".zzLocal(), message: "Connect WeChat official account ".localized() + name + " ." + "The official account name has copy to pasteboard.", preferredStyle: .alert)
        let cancel = UIAlertAction(title:"Cancel".zzLocal(), style: .cancel, handler: nil)
        av.addAction(cancel)
        let done = UIAlertAction(title: "Open WeChat".zzLocal(), style: .default) { (_) in
            if let url = URL(string: "weixin://") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly:NSNumber(booleanLiteral: false)], completionHandler: nil)
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
            mvc.setSubject("Feedback".zzLocal())
            mvc.setToRecipients(["hellobanny@gmail.com"])
            var version = ""
            let vobj: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
            if let ver = vobj as? String{
                version = ver
            }
            let device = UIDevice.current
            let size = UIScreen.main.bounds.size
            mvc.setMessageBody("\n\n\n-----------------------------\n Name: \(appName)\n Device: \(device.localizedModel) \n OS Version:\(device.systemVersion)\n App Version:\(version)\n Screen Size: \(size.width) * \(size.height)\n", isHTML: false)
            mvc.popoverPresentationController?.sourceView = baseController.view
            mvc.popoverPresentationController?.sourceRect = baseController.view.bounds
            baseController.present(mvc, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Notice".zzLocal(), message: "Your device doesn't support send email.".zzLocal(), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK".zzLocal(), style: .cancel) { (action) in
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

extension ZZSetting:SKStoreProductViewControllerDelegate{
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension String{
    func zzLocal() -> String{
        let bundle = Bundle(for: ZZSetting.self as AnyClass)
        return self.localized(using: "ZZLibLocalizable", in: bundle)
    }
}
