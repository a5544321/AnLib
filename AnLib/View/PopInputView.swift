//
//  PopInputView.swift
//  AnLibrary
//
//  Created by Andy on 2022/5/27.
//

import Foundation
import UIKit

protocol PopInput {
    var inputTextField: UITextField! { get set }
    var titleLabel: UILabel! { get set }
    var okButton: UIButton! { get set }
    var cancelButton: UIButton! { get set }
    var onClickOK: ( (_ input: String)->() )? {get set}
}

open class AnPopInputView: UIView, PopInput {
    public var onClickOK: ((String) -> ())?
    
    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet public weak var okButton: UIButton!
    
    @IBOutlet public weak var cancelButton: UIButton!
    
    var mainView: UIView?
    
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
    
    public convenience init(message: String) {
        self.init(frame: .zero)
        titleLabel.text = message
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
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.setCornerRadius(radius: 12)
        
        self.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: contentView.bounds.height).isActive = true
//        self.bounds.size = contentView.bounds.size
    }
    
    func customInit() {
        okButton.addTarget(self, action: #selector(clickOK), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        
    }
    
    
    public func showIn(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.7, constant: 0).isActive = true
        
        let backButton = UIButton()
        backButton.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        

    }
    
    @objc func clickOK() {
        onClickOK?(inputTextField.text ?? "")
        self.removeFromSuperview()
    }
    @objc func clickCancel() {
        self.removeFromSuperview()
    }
}
