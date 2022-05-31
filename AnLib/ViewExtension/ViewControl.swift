//
//  ViewControl.swift
//  AnLibrary
//
//  Created by Andy on 2021/8/17.
//

import Foundation
import UIKit
// MARK: - ViewControl
private var viewTapAssociate: UInt8 = 1
public extension UIView {
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        if gesture.state == .changed {
            var center = gesture.view?.center
            let translation = gesture.translation(in: gesture.view)
            //放大縮小後 移動
            let scale = gesture.view?.transform.a
            center = CGPoint(x: center!.x + (translation.x * scale!), y: center!.y + (translation.y * scale!))
            gesture.view?.center = center!
            gesture.setTranslation(CGPoint.zero, in: gesture.view)
        }
    }
    @objc func handlePinch(gesture: UIPinchGestureRecognizer){
        switch gesture.state {
            case .changed:
                self.transform = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1
                
            default:
                break
        }
    }
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if let tap = tapBlock {
            tap(gesture)
        }
    }
    
    var tapBlock: ((_ gesture: UITapGestureRecognizer) -> ())? {
        get { return objc_getAssociatedObject(self, &viewTapAssociate) as? (_ gesture: UITapGestureRecognizer) -> ()  }
        set { objc_setAssociatedObject(self, &viewTapAssociate, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

public protocol MoveableView {
    func addMoveGesture()
}
public protocol ScaleableView {
    func addPinchGesture()
}
public protocol TapableView {
    func addTapGesture(handler: @escaping (_ gesture: UITapGestureRecognizer) -> ())
}

public extension TapableView where Self: UIView{
    
    func addTapGesture(handler: @escaping (_ gesture: UITapGestureRecognizer) -> ()){
        let tg = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        self.addGestureRecognizer(tg)
        self.isUserInteractionEnabled = true
        self.tapBlock = handler
    }
    
}

public extension MoveableView where Self: UIView{
    func addMoveGesture(){
        let pg = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.addGestureRecognizer(pg)
        self.isUserInteractionEnabled = true
    }
    
}

public extension ScaleableView where Self: UIView{
    
    func addPinchGesture(){
        let pg = UIPinchGestureRecognizer(target: self,
                                          action: #selector(handlePinch(gesture:)))
        self.addGestureRecognizer(pg)
        self.isUserInteractionEnabled = true
    }
    
}

extension UIView: MoveableView, ScaleableView, TapableView {}
