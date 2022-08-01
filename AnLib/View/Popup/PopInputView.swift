//
//  PopInputView.swift
//  AnLibrary
//
//  Created by Andy on 2022/5/27.
//

import Foundation
import UIKit

protocol PopInput: PopupBasic {
    var inputTextField: UITextField! { get set }
}

open class AnPopInputView: AnPopupBasicView, PopInput {
        
    @IBOutlet weak var inputTextField: UITextField!
    
    
    @objc override func clickOK() {
        onClickOK?(inputTextField.text ?? "")
        self.removeFromSuperview()
    }
    
    @objc override func onBackgroudClick(sender: UIButton) {
        endEditing(true)
    }
}
