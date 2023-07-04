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
