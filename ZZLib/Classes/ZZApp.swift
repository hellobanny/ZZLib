//
//  ZZApp.swift
//  ZZLib
//
//  Created by 张忠 on 2019/1/5.
//

import UIKit
import Localize_Swift

enum ZZApp {
    case myGoals
    case planimeter
    case memory
    case magnify
    case artmap
    case measure
    case monotasking
    
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
        }
    }
    
    func appIcon() -> UIImage?{
        return UIImage(named: appId())
    }
    
    func appTitle() -> String{
        switch self {
        case .myGoals:
            return "My Goals".localized(using: "ZZLibLocalizable")
        case .planimeter:
            return "Planimeter".localized(using: "ZZLibLocalizable")
        case .memory:
            return "Memory".localized(using: "ZZLibLocalizable")
        case .magnify:
            return "Magnify".localized(using: "ZZLibLocalizable")
        case .artmap:
            return "ArtMap".localized(using: "ZZLibLocalizable")
        case .measure:
            return "Measure".localized(using: "ZZLibLocalizable")
        case .monotasking:
            return "Monotasking".localized(using: "ZZLibLocalizable")
        }
    }
    
    func appDescription() -> String{
        switch self {
        case .myGoals:
            return "Self management and todo list".localized(using: "ZZLibLocalizable")
        case .planimeter:
            return "Measure area and distance".localized(using: "ZZLibLocalizable")
        case .memory:
            return "Ebbinghaus forgetting curve".localized(using: "ZZLibLocalizable")
        case .magnify:
            return "Magnify screenshot for developer".localized(using: "ZZLibLocalizable")
        case .artmap:
            return "Create wallpaper from map".localized(using: "ZZLibLocalizable")
        case .measure:
            return "Measure area and distance by AutoNavi".localized(using: "ZZLibLocalizable")
        case .monotasking:
            return "Timer tool for monotasking".localized(using: "ZZLibLocalizable")
        }
    }
}
