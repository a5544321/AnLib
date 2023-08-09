//
//  CustomPopupInputView.swift
//  AnLibDemo
//
//  Created by Andy on 2022/5/30.
//

import Foundation
import UIKit
import AnLib
class CustomPopupInputView:  AnPopInputView{
    override func layoutSubviews() {
        okButton?.setCornerRadius(radius: 10)
    }
}
