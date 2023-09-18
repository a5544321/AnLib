//
//  NibOwnerLoadable.swift
//  MiVueGoUI
//
//  Created by Andy on 2021/5/31.
//  Copyright © 2021 FusionNext. All rights reserved.
//

import Foundation
import UIKit

//  https://medium.com/@bhupendra.trivedi14/understanding-custom-uiview-in-depth-setting-file-owner-vs-custom-class-e2cab4bb9df8

// https://medium.com/jeremy-xue-s-blog/swift-%E5%89%B5%E5%BB%BA%E8%87%AA%E5%AE%9A%E7%BE%A9%E8%A6%96%E5%9C%96-customview-8d61402ae937

public protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}

// MARK: - Default implmentation
public extension NibOwnerLoadable {
    
    static var nib: UINib {
        #if SWIFT_PACKAGE
        if Bundle.module.path(forResource: String(describing: self), ofType: "nib") != nil {
            return UINib(nibName: String(describing: self), bundle: Bundle.module)
        } else {
            return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
        }
        #else
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
        #endif
    }
}

// MARK: - Supporting methods
public extension NibOwnerLoadable where Self: UIView {
    
    func loadNibContent() {
        guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
            let contentView = views.first else {
                fatalError("Fail to load \(self) nib content")
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
