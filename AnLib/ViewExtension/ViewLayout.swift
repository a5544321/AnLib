//
//  ViewLayout.swift
//  AnLibrary
//
//  Created by Andy on 2022/5/27.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintFitSuperViewByCenter() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [centerXAnchor.constraint(equalTo: superView.centerXAnchor),
             centerYAnchor.constraint(equalTo: superView.centerYAnchor),
             widthAnchor.constraint(equalTo: superView.widthAnchor),
             heightAnchor.constraint(equalTo: superView.heightAnchor)])
    }
    
    
}

//--------------------------------------------------------------------------------
// MARK: - Corner Radius
//--------------------------------------------------------------------------------
public extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setRoundBorder(color: UIColor) {
        self.layer.cornerRadius = self.bounds.height * 0.5
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func circleBackground() {
        setCornerRadius(radius: self.bounds.height * 0.5)
    }
}
