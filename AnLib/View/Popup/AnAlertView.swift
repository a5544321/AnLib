//
//  AnAlertView.swift
//  AnLib
//
//  Created by Andy on 2022/8/23.
//

import UIKit
@available(iOS 13.0, *)
public class AnAlertView: AnPopupBasicView {
    
    @IBOutlet weak var titleTopToImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopToSuperConstraint: NSLayoutConstraint!
    @IBOutlet weak var okBottomToSuperConstraint: NSLayoutConstraint!
    @IBOutlet weak var okBottomToCancelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mImageView: UIImageView!
    var mImage: UIImage?
    var cancelTitle: String?
    
    public init(title: String?, message: String?, image: UIImage?, popStyle: PopStyle = .alert) {
        
        mImage = image
        super.init(title: title, message: message, size: nil, popStyle: popStyle)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setImageTintColor(color: UIColor) {
        mImageView.tintColor = color
    }
    
    override func adjustHeight() {
        if mImage != nil {
            mImageView.image = mImage
            mainHeightConstraint?.constant = 300
        } else {
            mImageView.isHidden = true
            mainHeightConstraint?.constant = 220
            titleTopToImageConstraint.isActive = false
            titleTopToSuperConstraint.isActive = true
        }
        
        if !(cancelButton?.isHidden ?? true) {
            okBottomToCancelConstraint.isActive = true
            okBottomToSuperConstraint.isActive = false
            mainHeightConstraint?.constant += 50
            
        } else {
            cancelButton?.isHidden = true
            okBottomToCancelConstraint.isActive = false
            okBottomToSuperConstraint.isActive = true
            
        }
        
        super.adjustHeight()
    }
    
}
