//
//  LocalizeLabel.swift
//  AnLib
//
//  Created by Andy on 2023/3/24.
//

import UIKit

open class LocalizeLabel: UILabel {
    @IBInspectable var localizeKey: String?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let key = localizeKey {
            text = NSLocalizedString(key, comment: "")
        }
    }
}

open class LocalizeButton: UIButton {
    @IBInspectable var localizeKey: String?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let key = localizeKey {
            let text = NSLocalizedString(key, comment: "")
            setTitle(text, for: .normal)
        }
    }
}
