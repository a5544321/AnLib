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
    private let msgNormalColor: UIColor = UIColor(hex: "#9B9B9B")
    public var placeholderColor: UIColor = UIColor(hex: "#909090")
    public weak var delegate: AnMessageTextFieldDelegate?
    let cr: CGFloat = 6
    public var textLimitCount: Int = -1 {
        didSet {
            if textLimitCount > 0 {
                updateCountLabel()
                countLabel.isHidden = false
            } else {
                countLabel.isHidden = true
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var topContainerView: UIView! {
        didSet {
            topContainerView.setCornerRadius(radius: cr)
        }
    }
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
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
    
    public var placeHolder: String? {
        didSet {
            textField.placeholder = placeHolder
        }
    }
    
    public var isEmpty: Bool {
        return (textField.text?.isEmpty ?? true)
    }
    public var textContentType: UITextContentType {
        get {
            textField.textContentType
        }
        set {
            textField.textContentType = newValue
        }
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
        textField.isHidden = true
        titleLabel.isHidden = true
        checkSecureType()
        textField.addTarget(self, action: #selector(textFieldEditingChangedAction), for: .editingChanged)
        rightButton.imageView?.tintColor = UIColor(hex: "#CECECE")
        rightButton.isHidden = true
        let tg = UITapGestureRecognizer(target: self, action: #selector(didTapTop))
        topContainerView.addGestureRecognizer(tg)
    }
    
    func checkSecureType() {
        if isPasswordType {
            textField.isSecureTextEntry = true
            rightButton.setImage(UIImage(named: "ic_pwd_close", in: Bundle(for: AnMessageTextField.self), compatibleWith: nil), for: .normal)
            rightButton.setImage(UIImage(named: "ic_pwd_open", in: Bundle(for: AnMessageTextField.self), compatibleWith: nil), for: .selected)
            rightButton.addTarget(self, action: #selector(secureTextEntryButtonAction(_:)), for: .touchUpInside)
        } else {
            textField.isSecureTextEntry = false
            rightButton.removeTarget(self, action: #selector(secureTextEntryButtonAction(_:)), for: .touchUpInside)
        }
    }
    
    @objc func didTapTop() {
        self.textField.becomeFirstResponder()
    }
    
    public func setTitle(title: String, placeholder: String?) {
        titleLabel.text = title
        coverLabel.text = title
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
    }
    
    public func setText(text: String?) {
        textField.text = text
        textField.isHidden = isEmpty
        titleLabel.isHidden = isEmpty
        coverLabel.isHidden = !isEmpty
        rightButton.isHidden = !isPasswordType || isEmpty
    }
    
    public func showErrorMessage(errMsg: String) {
        topContainerView.setBorder(color: errorRed, cornerRadius: cr)
        messageLabel.textColor = errorRed
        messageLabel.isHidden = false
        messageLabel.text = errMsg
    }
    
    public func showNormalMessage(msg: String) {
        topContainerView.layer.borderColor = UIColor.clear.cgColor
        messageLabel.textColor = msgNormalColor
        messageLabel.isHidden = false
        messageLabel.text = msg
    }
    
    public func cancelError() {
        if messageLabel.textColor == errorRed {
            hideMessage()
        }
    }
    
    public func hideMessage() {
        messageLabel.isHidden = true
        topContainerView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func updateCountLabel() {
        guard textLimitCount > 0 else {
            return
        }
        
        countLabel.text = String(format: "%d/%d", text?.count ?? 0, textLimitCount)
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
        rightButton.isHidden = !isPasswordType
        titleLabel.isHidden = false
        textField.isHidden = false
        coverLabel.isHidden = true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(sender: self)
        rightButton.isHidden = !isPasswordType || isEmpty
        titleLabel.isHidden = isEmpty
        textField.isHidden = isEmpty
        coverLabel.isHidden = !isEmpty
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(sender: self) ?? true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textLimitCount > 0 else {
            return true
        }
        if string.isEmpty {
            return true
        }
        
        return textField.text?.count ?? 0 < textLimitCount
    }
    
    @objc private func textFieldEditingChangedAction() {
        updateCountLabel()
        delegate?.textFieldDidChanged(sender: self)
        cancelError()
    }
}
