//
//  ZZUserGuideICloud.swift
//  Pods
//
//  Created by 张忠 on 2017/9/1.
//
//

import Foundation

public class ZZUserGuideICloud: NSObject {
    private var allGuides = [ZZGuide]()
    
    public static let shared : ZZUserGuideICloud = {
        let instance = ZZUserGuideICloud()
        return instance
    }()
    
    public func appendGuides(_ guides:[ZZGuide]) {
        allGuides.append(contentsOf: guides)
    }
    
    public func valueOfKey(_ key:String) -> String? {
        for gd in allGuides{
            if gd.key == key {
                return gd.value
            }
        }
        return nil
    }
    
    //显示一个提示，如果必要的话
    public func showIfRequireGuide(_ key:String,turnOffNow:Bool,call: @escaping (_ title:String) -> Void){
        if !self.isGuideFinish(key) {
            for gd in allGuides{
                if gd.key == key {
                    call(gd.value)
                    if turnOffNow {
                        self.turnOffGuild(key)
                    }
                }
            }
        }
    }
    
    public func isGuideFinish(_ key:String)-> Bool{
        return NSUbiquitousKeyValueStore.default().bool(forKey: key)
    }
    
    public func turnOffGuild(_ key:String){
        let ud = NSUbiquitousKeyValueStore.default()
        ud.set(true, forKey: key)
        ud.synchronize()
    }
    
    public func resetGuide(_ key:String){
        let ud = NSUbiquitousKeyValueStore.default()
        ud.set(false, forKey: key)
        ud.synchronize()
    }
    
    public func resetGuides(){
        let ud = NSUbiquitousKeyValueStore.default()
        for guide in allGuides{
            ud.set(false, forKey: guide.key)
        }
        ud.synchronize()
    }
}
