//
//  PopInputView.swift
//  AnLibrary
//
//  Created by Andy on 2022/5/27.
//

import Foundation
import UIKit

protocol PopInput: PopupBasic {
    var inputTextField: UITextField? { get set }
    var inputTextView: UITextView? {get set}
}

open class AnPopInputView: AnPopupBasicView, PopInput {
        
    @IBOutlet public weak var inputTextField: UITextField?
    @IBOutlet public weak var inputTextView: UITextView?
    
    
    @objc open override func clickOK() {
        if let tf = inputTextField {
            onClickOK?(tf.text ?? "")
        }
        else if let tv = inputTextView {
            onClickOK?(tv.text)
        }
        self.removeFromSuperview()
    }
    
    @objc open override func onBackgroudClick(sender: UIButton) {
        endEditing(true)
    }
}
