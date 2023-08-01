//
//  UIExtension.swift
//  AnLib
//
//  Created by Andy on 2023/3/24.
//

import Foundation
import UIKit

public extension UIButton {
    var localKey: String {
        set (key) { setTitle(NSLocalizedString(key, comment: ""), for: .normal) }
        get { return titleLabel!.text! }
    }
}

public extension UIView {
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

public extension UITextView {
    func addLink(url: String, string: String) {
        let attributeString  = NSMutableAttributedString(attributedString: attributedText)
        attributeString.addAttribute(.link, value: url, range: (attributeString.string as NSString).range(of: string))
        self.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedText = attributeString
        isSelectable = true
        isEditable = false
    }
}
