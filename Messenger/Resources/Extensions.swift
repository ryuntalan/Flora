//
//  Extensions.swift
//  Messenger
//
//  Created by Ryan Untalan on 2/13/21.
//

import Foundation
import UIKit

extension UIView {

    public var width: CGFloat {
        return frame.size.width
    }

    public var height: CGFloat {
        return frame.size.height
    }

    public var top: CGFloat {
        return frame.origin.y
    }

    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }

    public var left: CGFloat {
        return frame.origin.x
    }

    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }

}

extension Notification.Name {
    /// Notificaiton  when user logs in
    static let didLogInNotification = Notification.Name("didLogInNotification")
}

public extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180.0
    }
}

extension Double {
    var toTimeString: String {
        let seconds: Int = Int(self.truncatingRemainder(dividingBy: 60.0))
        let minutes: Int = Int(self / 60.0)
        return String(format: "%d:%02d", minutes, seconds)
    }
}
