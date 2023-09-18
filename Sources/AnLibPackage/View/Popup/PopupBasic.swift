//
//  PopupBasic.swift
//  AnLib
//
//  Created by Andy on 2022/7/27.
//

import Foundation
import UIKit

protocol PopupBasic {
    var titleLabel: UILabel? { get set }
    var messageLabel: UILabel? { get set }
    var messageTextView: UITextView? { get set }
    var okButton: UIButton? { get set }
    var cancelButton: UIButton? { get set }
    var onClickOK: ( (_ input: Any?)->() )? {get set}
    var onClickCancel: ( ()->() )? {get set}
    func close()
}

extension PopupBasic where Self: UIView{
    func close() {
        self.removeFromSuperview()
    }
}

public enum PopStyle {
    case alert, bottom, bottomCard
}

open class AnPopupBasicView: UIView, PopupBasic {
    @IBOutlet public weak var titleLabel: UILabel?
    
    @IBOutlet public weak var messageLabel: UILabel?
    
    @IBOutlet public weak var messageTextView: UITextView?
    
    @IBOutlet public weak var okButton: UIButton?
    
    @IBOutlet public weak var cancelButton: UIButton?
    
    public var onClickOK: ((Any?) -> ())?
    
    public var onClickCancel: (() -> ())?
    
    public internal(set) var popStyle: PopStyle = .alert
    
    public var isDragable: Bool = true {
        didSet {
            topGestureView?.isHidden = !isDragable
        }
    }
    
    
    /// Popup view verticle position in parent view, 1 = center Y, default is 0.9
    public var verticleRate: Float = 0.9 {
        didSet{
            guard mainView != nil, popStyle != .bottomCard else {
                return
            }
            if let cons = centerYConstraint {
                self.removeConstraint(cons)
            }
            centerYConstraint = NSLayoutConstraint(item: mainView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: CGFloat(verticleRate), constant: 0)
            centerYConstraint?.isActive = true
        }
    }
    
    var showingTopConstant: CGFloat {
        return -(mainHeightConstraint?.constant ?? 245) - bottomMargin
    }
    
    public var mainView: UIView?
    var topGestureView: UIView?
    var bottomMargin: CGFloat = 30
    var needAdjustHeight: Bool = true
    var maxHeight: CGFloat?
    
    var customSize: CGSize?
    var centerYConstraint: NSLayoutConstraint?
    var titleHeightConstraint: NSLayoutConstraint?
    public var mainHeightConstraint: NSLayoutConstraint?
    var animateTopConstraint: NSLayoutConstraint?
    
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
    
    /// All element in Nib should set height except message label (Dynamic height)
    public init(title: String?, message: String?, size: CGSize? = nil, needAdjustHeight: Bool = true, popStyle: PopStyle = .alert) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        loadNib()
        self.needAdjustHeight = needAdjustHeight
        customInit()
        titleLabel?.text = title
        messageLabel?.text = message
        messageTextView?.text = message
        self.popStyle = popStyle
        self.customSize = size
        configSize()
        initConstraint()
    }
    
    func getNib() -> UINib {
        #if SWIFT_PACKAGE
        if Bundle.module.path(forResource: String(describing: self), ofType: "nib") != nil {
            return UINib(nibName: String(describing: self), bundle: Bundle.module)
        } else {
            return UINib(nibName: String(describing: self), bundle: Bundle(for: self.classForCoder))
        }
        #else
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self.classForCoder))
        #endif
    }
    
    public func loadNib() {
        let nib = getNib()
        guard let views = nib.instantiate(withOwner: self, options: nil) as? [UIView],
              let contentView = views.first else {
            fatalError("Fail to load \(self) nib content")
        }
        mainView = contentView
        mainView!.translatesAutoresizingMaskIntoConstraints = false
        mainView!.setCornerRadius(radius: 16)
        self.addSubview(mainView!)
    }
    
    open func initConstraint() {
        guard let contentView = mainView else {
            return
        }
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        if popStyle == .alert {
            centerYConstraint = NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: CGFloat(verticleRate), constant: 0)
            centerYConstraint?.isActive = true
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        } else if popStyle == .bottomCard{
            addTopIndicator()
            animateTopConstraint = contentView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            animateTopConstraint?.isActive = true
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.92).isActive = true
        } else if popStyle == .bottom {
            addTopIndicator()
            animateTopConstraint = contentView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            animateTopConstraint?.isActive = true
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            bottomMargin = 0
        }
        layoutIfNeeded()
    }
    
    open func configSize() {
        if customSize != nil {
            mainHeightConstraint = mainView?.heightAnchor.constraint(equalToConstant: customSize!.height)
            mainHeightConstraint!.isActive = true
        } else {
            mainHeightConstraint = mainView?.heightAnchor.constraint(equalToConstant: mainView!.bounds.height)
            mainHeightConstraint!.isActive = true
        }
        adjustHeight()
    }
    
    open func adjustHeight() {
        guard needAdjustHeight else {
            return
        }
        layoutIfNeeded()
        mainView?.layoutIfNeeded()
         // Sync frame size with constraint setting
        if let titleLabel = titleLabel {
            if titleHeightConstraint == nil {
                titleHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 25)
                titleHeightConstraint?.isActive = true
                titleLabel.layoutIfNeeded()
            }
            let cHeight = titleLabel.text?.height(withConstrainedWidth: titleLabel.bounds.width, font: titleLabel.font) ?? 0
            let diff = cHeight - titleLabel.bounds.height
            if diff > 0 {
                titleHeightConstraint?.constant = cHeight
                mainHeightConstraint?.constant = mainHeightConstraint!.constant + diff
            }
        }
        
        if let msgLabel = messageLabel {
            let calculateHeight =  msgLabel.text != nil ? msgLabel.text!.height(withConstrainedWidth: msgLabel.bounds.width, font: msgLabel.font) : 0
            let dif = calculateHeight - msgLabel.bounds.height
            mainHeightConstraint?.constant = mainHeightConstraint!.constant + dif
            if let max = maxHeight {
                mainHeightConstraint?.constant = min(mainHeightConstraint!.constant + dif, max)
            }
        } else if let msgTV = messageTextView {
            let calculateHeight =  msgTV.text != nil ? msgTV.text!.height(withConstrainedWidth: msgTV.bounds.width, font: msgTV.font!) : 0
            let dif = calculateHeight - msgTV.bounds.height
            mainHeightConstraint?.constant = mainHeightConstraint!.constant + dif
            if let max = maxHeight {
                mainHeightConstraint?.constant = min(mainHeightConstraint!.constant, max)
            }
        }
        layoutIfNeeded()
        mainView?.layoutIfNeeded()
        titleLabel?.layoutIfNeeded()
        messageLabel?.layoutIfNeeded()
    }
    
    public func setMessageAlignment(alignment: NSTextAlignment) {
        messageLabel?.textAlignment = alignment
        messageTextView?.textAlignment = alignment
    }
    
    /// Set OK button UI & action
    public func setOKButton(title: String, tintColor: UIColor, textColor: UIColor? = nil, isFill: Bool, action: ((Any?) -> ())?) {
        guard okButton != nil else {
            return
        }
        setButtonUI(title: title, tintColor: tintColor, textColor: textColor, isFill: isFill, button: okButton!)
        onClickOK = action
    }
    /// Only set OK action, equals to set onClickOK
    public func setOKAction(action: ((Any?) -> ())?) {
        onClickOK = action
    }
    /// Set Cancel button UI & action
    public func setCancelButton(title: String, tintColor: UIColor, textColor: UIColor? = nil, isFill: Bool, action: (() -> ())?) {
        guard cancelButton != nil else {
            return
        }
        setButtonUI(title: title, tintColor: tintColor, textColor: textColor, isFill: isFill, button: cancelButton!)
        onClickCancel = action
    }
    /// Only set Cancel action, equals to set onClickCancel
    public func setCancelAction(action: (() -> ())?) {
        onClickCancel = action
    }
    
    func setButtonUI(title: String, tintColor: UIColor, textColor: UIColor? = nil, isFill: Bool, button: UIButton) {
        button.setTitle(title, for: .normal)
        UIView.performWithoutAnimation {
            if isFill {
                button.backgroundColor = tintColor
                if let color = textColor {
                    button.setTitleColor(color, for: .normal)
                } else {
                    button.setTitleColor(.white, for: .normal)
                }
            } else {
                button.backgroundColor = .clear
                button.setRoundBorder(color: tintColor)
                button.setTitleColor(tintColor, for: .normal)
            }
            button.layoutIfNeeded()
        }
    }
    public func setTopIndicator(visible: Bool) {
        topGestureView?.isHidden = !visible
    }
    func addTopIndicator() {
        topGestureView = UIView()
        topGestureView?.translatesAutoresizingMaskIntoConstraints = false
        let indicator = UIView()
        indicator.backgroundColor = .lightGray
        indicator.setCornerRadius(radius: 2.5)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        topGestureView?.addSubview(indicator)
        
        mainView?.addSubview(topGestureView!)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleTopPan(_:)))
        topGestureView?.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate([topGestureView!.widthAnchor.constraint(equalTo: mainView!.widthAnchor, multiplier: 0.9),
//                                     topGestureView!.heightAnchor.constraint(equalToConstant: 19),
                                     topGestureView!.bottomAnchor.constraint(equalTo: messageLabel?.bottomAnchor ?? titleLabel?.bottomAnchor ?? okButton?.topAnchor ?? mainView!.bottomAnchor ),
                                     topGestureView!.topAnchor.constraint(equalTo: mainView!.topAnchor),
                                     topGestureView!.centerXAnchor.constraint(equalTo: mainView!.centerXAnchor),
                                     indicator.widthAnchor.constraint(equalToConstant: 40),
                                     indicator.heightAnchor.constraint(equalToConstant: 5),
                                     indicator.topAnchor.constraint(equalTo: topGestureView!.topAnchor, constant: 7),
                                     indicator.centerXAnchor.constraint(equalTo: topGestureView!.centerXAnchor)])
    }
    
    open func customInit() {
        messageTextView?.textContainer.lineFragmentPadding = 0
        messageTextView?.textContainerInset = .zero
        okButton?.addTarget(self, action: #selector(clickOK), for: .touchUpInside)
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
        
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        maxHeight = view.bounds.height * 0.8
        self.adjustHeight()
        layoutIfNeeded()
        
        if self.popStyle == .bottomCard || self.popStyle == .bottom
        {
            self.showBottomCard(show: true)
        }
//        UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve) {
//
//        } completion: { (com) in
//
//        }
    }
    
    @objc func handleTopPan(_ gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == .began {

        } else if gestureRecognizer.state == .changed {

            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)

            animateTopConstraint?.constant = max(showingTopConstant - 12, (animateTopConstraint!.constant + translation.y))

            gestureRecognizer.setTranslation(.zero, in: gestureRecognizer.view)
            
        } else if gestureRecognizer.state == .ended {
            if animateTopConstraint!.constant > showingTopConstant / 2 {
                clickCancel()
            } else {
                showBottomCard(show: true)
            }
        }
    }
    
    func showBottomCard(show: Bool) {
        let const = show ? showingTopConstant : 5
        if self.popStyle == .bottomCard || self.popStyle == .bottom,
           let constraint = self.animateTopConstraint
        {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
                constraint.constant = const
                self.layoutIfNeeded()
            } completion: { (p) in
                
            }
        }
    }
    
    @objc open func clickOK() {
        onClickOK?(nil)
        close()
    }
    @objc func clickCancel() {
        onClickCancel?()
        close()
    }
    
    
    
    open func close() {
        if self.popStyle == .bottomCard,
           let constraint = self.animateTopConstraint {
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.15, delay: 0, options: .curveLinear) {
                constraint.constant = 3
                self.layoutIfNeeded()
            } completion: { (p) in
                self.removeFromSuperview()
            }
        } else {
            self.removeFromSuperview()
        }
    }
    
    @objc open func onBackgroudClick(sender: UIButton) {
        endEditing(true)
    }
    
}
