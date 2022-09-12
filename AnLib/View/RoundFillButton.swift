//
//  RoundFillButton.swift
//  AnLib
//
//  Created by Andy on 2022/9/7.
//

import UIKit

class RoundFillButton: UIButton {
    @IBInspectable var mainColor: UIColor = .blue {
        didSet {
            setUI()
        }
    }
    @IBInspectable var isFill: Bool = true {
        didSet {
            setUI()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setCornerRadius(radius: bounds.height * 0.5)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    

    func setUI() {
        setCornerRadius(radius: bounds.height * 0.5)
        if isFill {
            backgroundColor = mainColor
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .clear
            setTitleColor(mainColor, for: .normal)
        }
    }
}
