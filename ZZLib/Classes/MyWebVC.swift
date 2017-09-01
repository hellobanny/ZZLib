//
//  MyWebVC.swift
//  Pods
//
//  Created by 张忠 on 2017/5/16.
//
//

import UIKit

public class MyWebVC: UIViewController {
    
    var webView: UIWebView!
    
    public var targetUrl:URL!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        webView = UIWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        //let top = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        //top.isActive = true
        webView.scalesPageToFit = true
        if (targetUrl != nil) {
            webView.loadRequest(URLRequest(url: targetUrl))
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(MyWebVC.done))
    }
    
    func done() {
        if isModal() {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    override public func viewDidLayoutSubviews() {
        // webView.frame = self.view.frame
        print(self.view.frame)
    }
    
    public func loadLocalFile(_ name:String,type:String){
        if let path = Bundle.main.path(forResource: name, ofType: type){
            targetUrl = URL(fileURLWithPath: path)
            if webView != nil {
                webView.loadRequest(URLRequest(url: targetUrl))
            }
        }
    }
    
    public func loadWebURL(_ urlstr:String){
        targetUrl = URL(string: urlstr)
        if webView != nil {
            webView.loadRequest(URLRequest(url: targetUrl))
        }
    }
}

