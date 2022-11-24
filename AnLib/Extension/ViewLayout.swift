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
    
    func setBorder(color: UIColor, width: CGFloat = 1) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func circleBackground() {
        setCornerRadius(radius: self.bounds.height * 0.5)
    }
    
    func cropRect(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth * scale, height: breadth * scale) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        print(breadthRect)
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize,
                                       format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
                .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
