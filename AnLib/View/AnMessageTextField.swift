//
//  AnMessageTextfield.swift
//  AnLib
//
//  Created by Andy on 2022/9/20.
//

import UIKit
public protocol AnMessageTextFieldDelegate: AnyObject {
    func textFieldDidBeginEditing(sender: AnMessageTextField)
    func textFieldDidEndEditing(sender: AnMessageTextField)
    func textFieldDidChanged(sender: AnMessageTextField)
    func textFieldShouldReturn(sender: AnMessageTextField) -> Bool
}
public class AnMessageTextField: UIView, NibOwnerLoadable  {
    private let errorRed: UIColor = UIColor(hex: "#E85C4A")
    public weak var delegate: AnMessageTextFieldDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var topContainerView: UIView! {
        didSet {
            topContainerView.setCornerRadius(radius: 6)
        }
    }
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBInspectable var title: String! = "" {
        didSet {
            titleLabel.text = title
            textField.placeholder = title
        }
    }
    
    @IBInspectable var isPasswordType: Bool = false {
        didSet {
            checkSecureType()
        }
    }
    
    public var isEditing: Bool {
        return textField.isEditing
    }
    
    public var text: String? {
        return textField.text
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        loadNibContent()
        textField.delegate = self
        checkSecureType()
        textField.addTarget(self, action: #selector(textFieldEditingChangedAction), for: .editingChanged)
        rightButton.imageView?.tintColor = UIColor(hex: "#CECECE")
    }
    
    func checkSecureType() {
        if isPasswordType {
            textField.isSecureTextEntry = true
            rightButton.isHidden = false
            rightButton.setImage(UIImage(named: "ic_pwd_close", in: Bundle(for: AnMessageTextField.self), compatibleWith: nil), for: .normal)
            rightButton.setImage(UIImage(named: "ic_pwd_open", in: Bundle(for: AnMessageTextField.self), compatibleWith: nil), for: .selected)
            rightButton.addTarget(self, action: #selector(secureTextEntryButtonAction(_:)), for: .touchUpInside)
        } else {
            textField.isSecureTextEntry = false
            rightButton.isHidden = true
            rightButton.removeTarget(self, action: #selector(secureTextEntryButtonAction(_:)), for: .touchUpInside)
        }
    }
    
    public func setTitle(title: String) {
        titleLabel.text = title
    }
    
    public func setText(text: String?) {
        textField.text = text
    }
    
    public func showErrorMessage(errMsg: String) {
        topContainerView.setBorder(color: errorRed)
        messageLabel.isHidden = false
        messageLabel.text = errMsg
    }
    
    public func hideErrorMessage() {
        messageLabel.isHidden = true
        topContainerView.layer.borderColor = UIColor.clear.cgColor
    }
    
    public func startEditing() {
        textField.becomeFirstResponder()
    }
    public func endEditing() {
        textField.resignFirstResponder()
    }
    
    @objc private func secureTextEntryButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        textField.isSecureTextEntry = !sender.isSelected
    }

}

extension AnMessageTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(sender: self)
        hideErrorMessage()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(sender: self)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(sender: self) ?? true
    }
    
    @objc private func textFieldEditingChangedAction() {
        delegate?.textFieldDidChanged(sender: self)
    }
}
