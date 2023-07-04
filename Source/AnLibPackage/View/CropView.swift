//
//  CropView.swift
//  EyePhoto
//
//  Created by O1-Developer on 2020/1/14.
//  Copyright © 2020 O1-Developer. All rights reserved.
//

import UIKit

public class CropView: UIView {
    private var imageView: UIImageView = UIImageView()
    private let circleLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()
    private let margin: CGFloat = 10
    public var originImage: UIImage? {
        didSet {
            imageView.image = originImage
        }
    }
    var needMask: Bool = true {
        didSet {
            if !needMask {
                self.maskLayer.removeFromSuperlayer()
            }
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            relayout()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public override func layoutSubviews() {
       
    }
    
    func relayout() {
//        imageView.frame = self.bounds
        let length = min(self.bounds.size.width, self.bounds.size.height)
        let radius = length / 2 - margin
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        circleLayer.path = path.cgPath
        
        let rPath = UIBezierPath(rect: self.bounds)
        rPath.append(path.reversing())
        maskLayer.path = rPath.cgPath
    }
    
    private func commonInit() {
        print(self.bounds)
        print(self.frame)
        self.clipsToBounds = true
//        print(self.center)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.image = UIImage(named: "eye.jpg")
        imageView.addMoveGesture()
        imageView.addPinchGesture()
        
        let length = min(self.bounds.size.width, self.bounds.size.height)
        let radius = length / 2 - margin
        
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 1.0
        circleLayer.frame = self.bounds
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        let rPath = UIBezierPath(rect: self.bounds)
        rPath.append(path.reversing())
        
        circleLayer.path = path.cgPath
        maskLayer.path = rPath.cgPath
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(maskLayer)
    }
    
    public func snapshotVisibleArea(margin: CGFloat) -> UIImage? {
       UIGraphicsBeginImageContext(CGSize(width: bounds.size.width - (2 * margin), height: bounds.size.height - (2 * margin)) )
       let context:CGContext = UIGraphicsGetCurrentContext()!
       context.interpolationQuality = .high
       context.translateBy(x: -margin, y: -margin)
       layer.render(in: UIGraphicsGetCurrentContext()!)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return image
    }
    
//    func snapCircle() -> UIImage? {
////        print(circleLayer.path?.boundingBoxOfPath)
//        print(image?.ciImage)
//        print(image?.cgImage)
//        circleLayer.strokeColor = UIColor.clear.cgColor
//        let circleBound = circleLayer.path!.boundingBoxOfPath
//        UIGraphicsBeginImageContext(circleBound.size)
//        UIGraphicsBeginImageContextWithOptions(circleBound.size, false, imageView.image!.scale)
//        let context:CGContext = UIGraphicsGetCurrentContext()!
//        context.interpolationQuality = .high
//        context.translateBy(x: -circleBound.minX, y: -circleBound.minY)
//        layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        circleLayer.strokeColor = UIColor.red.cgColor
//        print(image!.scale)
//        return image?.circleMasked
//    }
    public func snapCircle() -> UIImage? {
        let circleBound = circleLayer.path!.boundingBoxOfPath
        let renderer = UIGraphicsImageRenderer(bounds: circleBound)
        let image = renderer.image { (rendererContext) in
            layer.render(in: rendererContext.cgContext)
        }
        print(image.scale)
        return image.circleMasked
    }
    
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: circleLayer.path!.boundingBoxOfPath)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
