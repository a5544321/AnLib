//
//  PopupBasic.swift
//  AnLib
//
//  Created by Andy on 2022/7/27.
//

import Foundation
import UIKit

protocol PopupBasic {
    var titleLabel: UILabel! { get set }
    var messageLabel: UILabel? { get set }
    var okButton: UIButton! { get set }
    var cancelButton: UIButton? { get set }
    var onClickOK: ( (_ input: Any?)->() )? {get set}
    var onClickCancel: ( ()->() )? {get set}
}

open class AnPopupBasicView: UIView, PopupBasic {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel?
    
    @IBOutlet public weak var okButton: UIButton!
    
    @IBOutlet public weak var cancelButton: UIButton?
    
    public var onClickOK: ((Any?) -> ())?
    
    public var onClickCancel: (() -> ())?
    
    
    /// Popup view verticle position in parent view, 1 = center Y, default is 0.7
    public var verticleRate: Float = 0.7 {
        didSet{
            if let cons = centerYConstraint {
                self.removeConstraint(cons)
            }
            guard mainView != nil else {
                return
            }
            centerYConstraint = NSLayoutConstraint(item: mainView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: CGFloat(verticleRate), constant: 0)
            centerYConstraint?.isActive = true
        }
    }
    
    var mainView: UIView?
    
    var centerYConstraint: NSLayoutConstraint?
    var mainHeightConstraint: NSLayoutConstraint?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        customInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        customInit()
    }
    
    public convenience init(title: String?, message: String?) {
        self.init(frame: .zero)
        titleLabel.text = title
        messageLabel?.text = message
        if let msg = message,
           let msgLabel = messageLabel{
            let calculateHeight = msg.height(withConstrainedWidth: msgLabel.bounds.width, font: msgLabel.font)
            let dif = calculateHeight - msgLabel.bounds.height
//            msgLabel.bounds.size.height = calculateHeight
            if dif > 0 {
                mainHeightConstraint?.constant = mainView!.bounds.height + dif
            }
        }
    }
    
    public func loadNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle:Bundle(for: self.classForCoder))
        guard let views = nib.instantiate(withOwner: self, options: nil) as? [UIView],
            let contentView = views.first else {
                fatalError("Fail to load \(self) nib content")
        }
        mainView = contentView
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        centerYConstraint = NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: CGFloat(verticleRate), constant: 0)
        centerYConstraint?.isActive = true
        
        contentView.setCornerRadius(radius: 12)
        
        contentView.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        mainHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: contentView.bounds.height)
        mainHeightConstraint!.isActive = true
    }
    
    func customInit() {
        okButton.addTarget(self, action: #selector(clickOK), for: .touchUpInside)
        cancelButton?.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        
    }
    
    public func showIn(view: UIView) {
        
        let backButton = UIButton()
        backButton.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backButton, at: 0)
        
        backButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        backButton.addTarget(self, action: #selector(onBackgroudClick(sender:)), for: .touchUpInside)
        
        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve) {
            self.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(self)
            
            self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } completion: { (com) in
            
        }
    }
    
    
    @objc func clickOK() {
        onClickOK?(nil)
        self.removeFromSuperview()
    }
    @objc func clickCancel() {
        onClickCancel?()
        self.removeFromSuperview()
    }
    
    @objc func onBackgroudClick(sender: UIButton) {
        endEditing(true)
    }
    
}
