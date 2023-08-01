//
//  AnClickScoreView.swift
//  AnLib
//
//  Created by Andy on 2023/7/7.
//

import UIKit

protocol AnClickScoreViewDelegate: NSObjectProtocol{
    func scoreViewDidScored(sender: AnClickScoreView, score: Int)
}

@IBDesignable
class AnClickScoreView: UIView {

    
    private var btnArray: [UIButton] = []
    private var mStackView: UIStackView!
    weak var delegate: AnClickScoreViewDelegate?
    
    @IBInspectable var score: Int = 3 {
        didSet {
            reloadScore()
        }
    }
    
    @IBInspectable var maxScore: Int = 5 {
        didSet {
            mStackView.removeAllSubviews()
            mStackView.removeFromSuperview()
            mStackView = nil
            setupViews()
        }
    }
    
    @IBInspectable var imageScore :UIImage = UIImage(systemName: "star.fill")! {
        didSet{
            for button :UIButton in btnArray {
                button.setImage(imageScore, for: .normal)
            }
        }
    }
    
    @IBInspectable var scoreTintColor: UIColor = .yellow {
        didSet {
            for button :UIButton in btnArray {
                button.tintColor = scoreTintColor
            }
        }
    }
    
    @IBInspectable var scoreSpacing: CGFloat = 0 {
        didSet {
            mStackView.spacing = scoreSpacing
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    convenience init(frame: CGRect, max: Int, delegate: AnClickScoreViewDelegate) {
        self.init(frame: frame)
        maxScore = max
        self.delegate = delegate
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func setupViews() {
        mStackView = UIStackView(frame: self.bounds)
        mStackView.axis = .horizontal
        mStackView.alignment = .center
        mStackView.distribution = .fillEqually
        mStackView.spacing = scoreSpacing
        for i in 1...maxScore {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action:#selector(onScoreBtnClick(clickedBtn:)) , for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFit
            button.adjustsImageWhenHighlighted = false
            button.tag = i
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.alpha = (button.tag <= score) ? 1.0 : 0.3
            button.setImage(imageScore, for: .normal)
            button.tintColor = scoreTintColor
            mStackView.addArrangedSubview(button)
            
            btnArray.append(button)
            // Height constraint
            button.heightAnchor.constraint(equalTo: mStackView.heightAnchor).isActive = true
        }
        addSubview(mStackView)
    }
    
    private func reloadScore() {
        var delay :Float = 0
        for button :UIButton in btnArray {
            if button.tag <= score
            {
                if button.alpha < 1
                {
                    UIView.animate(withDuration: 0.1,
                                   delay: TimeInterval(delay),
                                   options: .curveLinear,
                                   animations: {
                                    button.alpha = 1.0
                                    button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    },
                                   completion: { (finish) in
                                    UIView.animate(withDuration: 0.05, animations: {
                                        button.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                    })
                    
                    delay += 0.1
                    
                }
                
                
            }
            else
            {
                button.alpha = 0.3
            }
        }
    }
    
    @objc func onScoreBtnClick(clickedBtn :UIButton) {
        score = clickedBtn.tag
    }
}
