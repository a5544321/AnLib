//
//  AnActionAlertView.swift
//  AnLib
//
//  Created by Andy on 2023/9/5.
//

import UIKit

open class AnActionAlertView: AnPopupBasicView {
    @IBOutlet weak var titleTopToImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopToSuperConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mStackView: UIStackView!
    let buttonHeight = 48
    let stackMargin = 16
    private var image: UIImage?
    
    var roundButtons: [UIButton] = []
    var handlers: [actionHandler] = []
    public typealias actionHandler = ((UIButton) -> ())?
    
    public init(title: String?, message: String?, image: UIImage?, imageTintColor: UIColor?, popStyle: PopStyle = .bottomCard) {
        super.init(title: title, message: message, size: nil, popStyle: popStyle)
        self.image = image
        mImageView.image = image
        mImageView.tintColor = imageTintColor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setImageTintColor(color: UIColor) {
        mImageView.tintColor = color
    }
    
    @objc
    func onButtonClick(sender: UIButton) {
        let handler = handlers[sender.tag]
        handler?(sender)
        close()
    }
    
    public func addAction(title: String, mainColor: UIColor, textColor: UIColor = .white, isFill: Bool = true, action: actionHandler) {
        let roundButton = RoundFillButton(frame: CGRect(x: 0, y: 0, width: 0, height: buttonHeight))
        roundButton.mainColor = mainColor
        roundButton.setTitle(title, for: .normal)
        roundButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        roundButton.customTitleColor = textColor
        roundButton.isFill = isFill
        mStackView.addArrangedSubview(roundButton)
        roundButton.tag = roundButtons.count
        roundButton.addTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
        roundButtons.append(roundButton)
        
        handlers.append(action)
    }
    
    open override func adjustHeight() {
        if self.image != nil {
            mainHeightConstraint?.constant = 324
            imageHeightConstraint.constant = 96
            mImageView.isHidden = false
            titleTopToSuperConstraint.isActive = false
            titleTopToImageConstraint.isActive = true
        } else {
            mImageView.isHidden = true
            imageHeightConstraint.constant = 0
            mainHeightConstraint?.constant = 194
            titleTopToImageConstraint.isActive = false
            titleTopToSuperConstraint.isActive = true
        }
        
        if roundButtons.count > 0 {
            stackViewHeightConstraint.constant = CGFloat((roundButtons.count * buttonHeight) + ((roundButtons.count - 1) * stackMargin))
            mainHeightConstraint?.constant += CGFloat((roundButtons.count - 1) * (buttonHeight + stackMargin))
        }
        
        super.adjustHeight()
    }
}
