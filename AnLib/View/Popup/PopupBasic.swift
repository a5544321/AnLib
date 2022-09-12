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
    func close()
}

extension PopupBasic where Self: UIView{
    func close() {
        self.removeFromSuperview()
    }
}

public enum PopStyle {
    case alert, bottomCard
}
@available(iOS 13.0, *)
open class AnPopupBasicView: UIView, PopupBasic {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel?
    
    @IBOutlet public weak var okButton: UIButton!
    
    @IBOutlet public weak var cancelButton: UIButton?
    
    public var onClickOK: ((Any?) -> ())?
    
    public var onClickCancel: (() -> ())?
    
    public private(set) var popStyle: PopStyle = .alert
    
    
    /// Popup view verticle position in parent view, 1 = center Y, default is 0.7
    public var verticleRate: Float = 0.8 {
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
    
    var mainView: UIView?
    var topGestureView: UIView?
    let bottomMargin: CGFloat = 20
    
    var customSize: CGSize?
    var centerYConstraint: NSLayoutConstraint?
    var mainHeightConstraint: NSLayoutConstraint?
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
    public init(title: String?, message: String?, size: CGSize? = nil, popStyle: PopStyle = .alert) {
        super.init(frame: .zero)
        loadNib()
        customInit()
        titleLabel.text = title
        messageLabel?.text = message
        self.popStyle = popStyle
        self.customSize = size
        initConstraint()
        configSize()
    }
    
    public func loadNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle:Bundle(for: self.classForCoder))
        guard let views = nib.instantiate(withOwner: self, options: nil) as? [UIView],
            let contentView = views.first else {
                fatalError("Fail to load \(self) nib content")
        }
        mainView = contentView
        mainView!.translatesAutoresizingMaskIntoConstraints = false
        mainView!.setCornerRadius(radius: 12)
        self.addSubview(mainView!)
    }
    
    func initConstraint() {
        guard let contentView = mainView else {
            return
        }
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        if popStyle == .alert {
            centerYConstraint = NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: CGFloat(verticleRate), constant: 0)
            centerYConstraint?.isActive = true
            contentView.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        } else {
            addTopIndicator()
            animateTopConstraint = contentView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            animateTopConstraint?.isActive = true
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
        }
        
    }
    
    func configSize() {
        if customSize != nil {
            mainHeightConstraint = mainView?.heightAnchor.constraint(equalToConstant: customSize!.height)
            mainHeightConstraint!.isActive = true
        } else {
            mainHeightConstraint = mainView?.heightAnchor.constraint(equalToConstant: mainView!.bounds.height)
            mainHeightConstraint!.isActive = true
        }
        adjustHeight()
    }
    
    func adjustHeight() {
        if let msgLabel = messageLabel {
            let calculateHeight =  msgLabel.text != nil ? msgLabel.text!.height(withConstrainedWidth: msgLabel.bounds.width, font: msgLabel.font) : 0
            let dif = calculateHeight - msgLabel.bounds.height
//            if dif > 0 {
                mainHeightConstraint?.constant = mainHeightConstraint!.constant + dif
//            }
        }
    }
    
    public func setOKAction(title: String, tintColor: UIColor, isFill: Bool, action: ((Any?) -> ())?) {
        setButtonUI(title: title, tintColor: tintColor, isFill: isFill, button: okButton)
        onClickOK = action
    }
    
    public func setCancelAction(title: String, tintColor: UIColor, isFill: Bool, action: (() -> ())?) {
        guard cancelButton != nil else {
            return
        }
        cancelButton?.isHidden = false
        setButtonUI(title: title, tintColor: tintColor, isFill: isFill, button: cancelButton!)
        onClickCancel = action
        adjustHeight()
    }
    
    func setButtonUI(title: String, tintColor: UIColor, isFill: Bool, button: UIButton) {
        button.setTitle(title, for: .normal)
        if isFill {
            button.backgroundColor = tintColor
            button.setTitleColor(.white, for: .normal)
        } else {
            button.setTitleColor(tintColor, for: .normal)
        }
    }
    
    func addTopIndicator() {
        topGestureView = UIView()
        topGestureView?.translatesAutoresizingMaskIntoConstraints = false
        let indicator = UIView()
        indicator.backgroundColor = .systemGray2
        indicator.setCornerRadius(radius: 2.5)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        topGestureView?.addSubview(indicator)
        
        mainView?.addSubview(topGestureView!)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleTopPan(_:)))
        topGestureView?.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate([topGestureView!.widthAnchor.constraint(equalTo: mainView!.widthAnchor, multiplier: 0.8),
                                     topGestureView!.heightAnchor.constraint(equalToConstant: 19),
                                     topGestureView!.topAnchor.constraint(equalTo: mainView!.topAnchor),
                                     topGestureView!.centerXAnchor.constraint(equalTo: mainView!.centerXAnchor),
                                     indicator.widthAnchor.constraint(equalToConstant: 40),
                                     indicator.heightAnchor.constraint(equalToConstant: 5),
                                     indicator.centerYAnchor.constraint(equalTo: topGestureView!.centerYAnchor),
                                     indicator.centerXAnchor.constraint(equalTo: topGestureView!.centerXAnchor)])
    }
    
    func customInit() {
        okButton.addTarget(self, action: #selector(clickOK), for: .touchUpInside)
        cancelButton?.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        okButton.setCornerRadius(radius: 8)
        cancelButton?.setCornerRadius(radius: 8)
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
            if self.popStyle == .bottomCard
            {
                self.showBottomCard(show: true)
            }
        }
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
        if self.popStyle == .bottomCard,
           let constraint = self.animateTopConstraint
        {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
                constraint.constant = const
                self.layoutIfNeeded()
            } completion: { (p) in
                
            }
        }
    }
    
    @objc func clickOK() {
        onClickOK?(nil)
        close()
    }
    @objc func clickCancel() {
        onClickCancel?()
        close()
    }
    
    
    
    func close() {
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
    
    @objc func onBackgroudClick(sender: UIButton) {
        endEditing(true)
    }
    
}
