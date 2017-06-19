//
//  ZZUserGuide.swift
//  Pods
//
//  Created by 张忠 on 2017/6/19.
//
//
import Foundation

public class ZZUserGuide {
    
    private var allGuides = [ZZGuide]()
    
    public static let shared : ZZUserGuide = {
        let instance = ZZUserGuide()
        return instance
    }()
    
    public func appendGuides(_ guides:[ZZGuide]) {
        allGuides.append(contentsOf: guides)
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
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public func turnOffGuild(_ key:String){
        let ud = UserDefaults.standard
        ud.set(true, forKey: key)
        ud.synchronize()
    }
    
    public func resetGuide(_ key:String){
        let ud = UserDefaults.standard
        ud.set(false, forKey: key)
        ud.synchronize()
    }
    
    public func resetGuides(){
        let ud = UserDefaults.standard
        for guide in allGuides{
            ud.set(false, forKey: guide.key)
        }
        ud.synchronize()
    }
}
