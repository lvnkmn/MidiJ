import UIKit

extension UIUserInterfaceIdiom {
    
    var isIpad: Bool {
        switch self {
        case .pad:
            return true
        default:
            return false
        }
    }
    
    var isIphone: Bool {
        switch self {
        case .phone:
            return true
        default:
            return false
        }
    }
}
