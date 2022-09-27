//
//  RoundFillButton.swift
//  AnLib
//
//  Created by Andy on 2022/9/7.
//

import UIKit

public class RoundFillButton: UIButton {
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
        setTitleColor(.gray, for: .disabled)
        if isFill {
            backgroundColor = mainColor
            let tColor: UIColor = customTitleColor == nil ? .white : customTitleColor!
            setTitleColor(tColor, for: .normal)
            setTitleColor(tColor.withAlphaComponent(0.4), for: .highlighted)
        } else {
            backgroundColor = .clear
            setTitleColor(mainColor, for: .normal)
            setTitleColor(mainColor.withAlphaComponent(0.4), for: .highlighted)
            setRoundBorder(color: mainColor)
        }
        
    }
}
