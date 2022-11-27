//
//  TaskIcon.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import UIKit
import UIColor_Hex_Swift

enum TaskIcon {
    case icon1
    case icon2
    case icon3
    case icon4
    case icon5
    case icon6
    
    public var imageName: String {
        switch self {
        case .icon1: return "icon1"
        case .icon2: return "icon2"
        case .icon3: return "icon3"
        case .icon4: return "icon4"
        case .icon5: return "icon5"
        case .icon6: return "icon6"
        }
    }
    
    public var backgroundColor: UIColor {
        switch self {
        case .icon1: return UIColor("#DCA3C2")
        case .icon2: return UIColor("#C7CEF4")
        case .icon3: return UIColor("#D1A69B")
        case .icon4: return UIColor("#7894CF")
        case .icon5: return UIColor("#97D2E1")
        case .icon6: return UIColor("#F5D788")
        }
    }
    
}

extension NSObject {
    func getTaskIcon(_ iconName: String) -> TaskIcon {
        switch iconName {
        case "icon1":
            return .icon1
        case "icon2":
            return .icon2
        case "icon3":
            return .icon3
        case "icon4":
            return .icon4
        case "icon5":
            return .icon5
        case "icon6":
            return .icon6
        default:
            return .icon1
        }
    }
}
