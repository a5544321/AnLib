//
//  RoundFillButton.swift
//  AnLib
//
//  Created by Andy on 2022/9/7.
//

import UIKit

open class RoundFillButton: LocalizeButton {
    @IBInspectable public var mainColor: UIColor = .blue {
        didSet {
            setUI()
        }
    }
    @IBInspectable public var customTitleColor: UIColor?{
        didSet {
            setUI()
        }
    }
    @IBInspectable public var isFill: Bool = true {
        didSet {
            setUI()
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            setCornerRadius(radius: bounds.height * 0.5)
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            let bColor = isEnabled ? mainColor : UIColor(hex: "#808080").withAlphaComponent(0.12)
            if isFill {
                backgroundColor = bColor
                setRoundBorder(color: .clear)
            } else {
                setRoundBorder(color: bColor)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }

    func setUI() {
        setCornerRadius(radius: bounds.height * 0.5)
        setTitleColor(.gray, for: .disabled)
        if isFill {
            backgroundColor = isEnabled ? mainColor : UIColor(hex: "#808080").withAlphaComponent(0.12)
            let tColor: UIColor = customTitleColor == nil ? .white : customTitleColor!
            setTitleColor(tColor, for: .normal)
            setTitleColor(tColor.withAlphaComponent(0.4), for: .highlighted)
            setTitleColor(tColor.withAlphaComponent(0.24), for: .disabled)
        } else {
            backgroundColor = .clear
            setTitleColor(mainColor, for: .normal)
            setTitleColor(mainColor.withAlphaComponent(0.4), for: .highlighted)
            setTitleColor(UIColor.white.withAlphaComponent(0.24), for: .disabled)
            setRoundBorder(color: mainColor)
        }
        
    }
}
