//
//  AnToastView.swift
//  AnLib
//
//  Created by Andy on 2022/7/28.
//

import Foundation
import UIKit

public enum ColorStyle {
    case dark, black, white
}
public enum ToastLength: Double {
    case short = 1.0, medium = 2.0, long = 3.0
}
public enum ToastPosition {
    case top, mid, bottom
}

public class AnToastView: UIView {
    var leftImageView: UIImageView?
    var titleLabel: UILabel?
    var messageLabel: UILabel?
    var cancelButton: UIButton?
    var style: ColorStyle?
    var leftImage: UIImage?
    var isCancelable: Bool = true
    let margin: CGFloat = 8.0
    var mTitle: String!
    var viewHeightConstraint: NSLayoutConstraint!
    var titleHeightConstraint: NSLayoutConstraint!
    var messageHeightConstraint: NSLayoutConstraint?
    var mMessage: String?
    var length: ToastLength = .medium
    var titleTextColor = UIColor.black
    var messageTextColor = UIColor.black
    var cancelColor = UIColor.black
    var imageTintColor: UIColor?
    var position: ToastPosition!
    var borderDistance: CGFloat = 20.0
    
    var imageWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone{
            return 20
        } else {
            return 30
        }
    }
    var closeWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone{
            return 25
        } else {
            return 35
        }
    }
    
    public func setTitleTextColor(color: UIColor) {
        self.titleTextColor = color
    }
    public func setMessageTextColor(color: UIColor) {
        self.messageTextColor = color
    }
    public func setCancelColor(color: UIColor) {
        self.cancelColor = color
    }
    public func setImageColor(color: UIColor) {
        self.imageTintColor = color
    }
    
    public convenience init(title: String, message: String? = nil, image: UIImage? = nil, position: ToastPosition = .top, length: ToastLength = .medium, style: ColorStyle? = nil, isCancelable: Bool = true) {
        self.init(frame: .zero)
        backgroundColor = .white
        mTitle = title
        mMessage = message
        leftImage = image
        self.position = position
        self.length = length
        self.style = style
        self.isCancelable = isCancelable
        initLayout(title: mTitle, message: mMessage)
        
    }
    
    func updateHeight() {
        let titleHeight = mTitle.height(withConstrainedWidth: titleLabel!.bounds.width, font: titleLabel!.font)
        titleHeightConstraint.constant = titleHeight
        var totalHeight = titleHeight + 2 * margin
        if let msg = mMessage,
           let msgLb = messageLabel{
            let messageHeight = msg.height(withConstrainedWidth: msgLb.bounds.width, font: msgLb.font)
            messageHeightConstraint?.constant = messageHeight
            totalHeight += messageHeight + margin
        }
        viewHeightConstraint.constant = totalHeight
    }
    
    public override func layoutSubviews() {
        updateHeight()
        
    }
    
    
    func initLayout(title: String, message: String?) {
        // Left image view
        leftImageView = UIImageView(frame: .zero)
        leftImageView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftImageView!)
        NSLayoutConstraint.activate([leftImageView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     leftImageView!.widthAnchor.constraint(equalToConstant: imageWidth),
                                     leftImageView!.heightAnchor.constraint(equalToConstant: imageWidth),
                                     leftImageView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin)])
        
        // Close button
        if isCancelable {
            cancelButton = UIButton(frame: .zero)
//            cancelButton?.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold), forImageIn: .normal)
            cancelButton?.translatesAutoresizingMaskIntoConstraints = false
            cancelButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
            self.addSubview(cancelButton!)
            NSLayoutConstraint.activate([cancelButton!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                         cancelButton!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin),
                                         cancelButton!.widthAnchor.constraint(equalToConstant: closeWidth),
                                         cancelButton!.heightAnchor.constraint(equalToConstant: closeWidth)])
        }
        // Title label
        titleLabel = UILabel(frame: .zero)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel?.text = title
        titleLabel?.numberOfLines = 0
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel!)
        
        NSLayoutConstraint.activate([titleLabel!.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
                                     titleLabel!.leadingAnchor.constraint(equalTo: leftImageView!.trailingAnchor, constant: margin)])
        if isCancelable {
            titleLabel?.trailingAnchor.constraint(equalTo: cancelButton!.leadingAnchor, constant: -margin).isActive = true
        } else {
            titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: margin).isActive = true
        }
        let titleHeight = title.height(withConstrainedWidth: titleLabel!.bounds.width, font: titleLabel!.font)
        titleHeightConstraint = titleLabel?.heightAnchor.constraint(equalToConstant: titleHeight)
        titleHeightConstraint.isActive = true
        // Message label
        if let msg = message {
            messageLabel = UILabel(frame: .zero)
            messageLabel?.font = UIFont.systemFont(ofSize: 13)
            messageLabel?.text = msg
            messageLabel?.numberOfLines = 0
            messageLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(messageLabel!)
            NSLayoutConstraint.activate([messageLabel!.centerXAnchor.constraint(equalTo: titleLabel!.centerXAnchor),
                                         messageLabel!.widthAnchor.constraint(equalTo: titleLabel!.widthAnchor),
                                         messageLabel!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: margin)])
            let messageHeight = msg.height(withConstrainedWidth: messageLabel!.bounds.width, font: messageLabel!.font)
            messageHeightConstraint =  messageLabel?.heightAnchor.constraint(equalToConstant: messageHeight)
            messageHeightConstraint?.isActive = true
            
            let totalHeight = titleHeight + messageHeight + 3 * margin
            viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: totalHeight)
            viewHeightConstraint.isActive = true
        } else {
            let totalHeight = titleHeight + 2 * margin
            viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: totalHeight)
            viewHeightConstraint.isActive = true
        }
        
    }
    
    func loadUI() {
        self.setCornerRadius(radius: 12)
        if style != nil {
            if style == .black {
                titleTextColor = .white
                messageTextColor = .white
                cancelColor = .white
                backgroundColor = .black
            } else if style == .dark {
                titleTextColor = .white
                messageTextColor = .white
                cancelColor = .white
                backgroundColor = .darkGray
                
            } else {
                titleTextColor = .black
                messageTextColor = .black
                cancelColor = .black
                backgroundColor = .white
            }
        }
        titleLabel?.textColor = titleTextColor
        messageLabel?.textColor = messageTextColor
        if isCancelable {
//            cancelButton?.setImage(UIImage(systemName: "xmark"), for: .normal)
            cancelButton?.tintColor = cancelColor
        }
        
        if let img = leftImage {
            leftImageView?.image = img
            leftImageView?.tintColor = imageTintColor
        }
    }
    
    public func showIn(view: UIView) {
        loadUI()
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        self.alpha = 0
        NSLayoutConstraint.activate([self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                                     self.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        if self.position == .top {
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: borderDistance).isActive = true
        } else if self.position == .mid {
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        } else {
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -borderDistance).isActive = true
        }
        layoutIfNeeded()
        
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve) { [self] in
            self.alpha = 1
        } completion: { (com) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.length.rawValue) { [weak self] in
                guard let self = self else {
                    print("already closed")
                    return
                }
                self.close()
            }
        }
        
    }
    
    @objc func close() {
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
            self.alpha = 0
        } completion: { (complete) in
            self.removeFromSuperview()
        }

        
    }
}

public extension UIView {
    public func showToast(title: String, message: String? = nil, image: UIImage? = nil, position: ToastPosition = .top, length: ToastLength = .medium, style: ColorStyle? = nil, isCancelable: Bool = true) {
        let toast = AnToastView(title: title, message: message, image: image, position: position, length: length, style: style, isCancelable: isCancelable)
        
        toast.showIn(view: self)
    }
}
