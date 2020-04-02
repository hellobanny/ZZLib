//
//  ZZApp.swift
//  ZZLib
//
//  Created by 张忠 on 2019/1/5.
//

import UIKit
import Localize_Swift

public enum ZZApp {
    case myGoals
    case planimeter
    case memory
    case magnify
    case artmap
    case measure
    case monotasking
    case redbox
    case kuibu
    
    func appId() -> String {
        switch self {
        case .myGoals:
            return "1051212505"
        case .planimeter:
            return "476039389"
        case .memory:
            return "1180462374"
        case .magnify:
            return "1343107741"
        case .artmap:
            return "1440462856"
        case .measure:
            return "1250815924"
        case .monotasking:
            return "1329154894"
        case .redbox:
            return "1473577627"
        case .kuibu:
            return "1494266625"
        }
    }
    
    func appIcon(bundle:Bundle) -> UIImage?{
        if let path = bundle.path(forResource: appId(), ofType: "jpg"){
            return UIImage(contentsOfFile: path)
        }
        return UIImage(named: appId())
    }
    
    func appTitle() -> String{
        print(Localize.currentLanguage())
        switch self {
        case .myGoals:
            return "My Goals".zzLocal()
        case .planimeter:
            return "Planimeter".zzLocal()
        case .memory:
            return "Memory".zzLocal()
        case .magnify:
            return "Magnify".zzLocal()
        case .artmap:
            return "ArtMap".zzLocal()
        case .measure:
            return "Measure".zzLocal()
        case .monotasking:
            return "Monotasking".zzLocal()
        case .redbox:
            return "Redbox".zzLocal()
        case .kuibu:
            return "Kuibu".zzLocal()
        }
    }
    
    func appDescription() -> String{
        switch self {
        case .myGoals:
            return "Self management and todo list".zzLocal()
        case .planimeter:
            return "Measure area and distance".zzLocal()
        case .memory:
            return "Ebbinghaus forgetting curve".zzLocal()
        case .magnify:
            return "Magnify screenshot for developer".zzLocal()
        case .artmap:
            return "Create wallpaper from map".zzLocal()
        case .measure:
            return "Measure area and distance by AutoNavi".zzLocal()
        case .monotasking:
            return "Timer tool for monotasking".zzLocal()
        case .redbox:
            return "Many cool tools in one box".zzLocal()
        case .kuibu:
            return "Manage your life by number".zzLocal()
        }
    }
}
