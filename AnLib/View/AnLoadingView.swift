//
//  AnLoadingView.swift
//  AnLibrary
//
//  Created by Andy on 2021/8/17.
//

import UIKit

class AnLoadingView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    init(message: String? = nil, textColor: UIColor, loadStyle: UIActivityIndicatorView.Style) {
        super.init(frame: .zero)
        customInit()
        let activityIndicatorView = UIActivityIndicatorView(style: loadStyle)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate(
            [activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
             ])
        
        if let message = message {
            let label = UILabel(frame: .zero)
            label.textColor = textColor
            label.textAlignment = .center
            label.text = message
            label.font = UIFont.italicSystemFont(ofSize: 11)
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            
            NSLayoutConstraint.activate(
                [label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                 label.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 12),
                 label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
                 label.heightAnchor.constraint(equalToConstant: 30)
                 ])
        }
        activityIndicatorView.startAnimating()
        
    }
    
    private func customInit() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    convenience init(message: String?) {
        self.init(message: message, textColor: UIColor.white, loadStyle: .medium)
    }
    convenience init() {
        self.init(message: nil, textColor: UIColor.white, loadStyle: .medium)
    }

    
}

extension UIView {
    func showLoading(message: String?) {
        let loadingView = AnLoadingView(message: message)
        self.addSubview(loadingView)
        loadingView.addConstraintFitSuperViewByCenter()
    }
    
    func stopLoading() {
        for view in subviews {
            if let loadingView = view as? AnLoadingView {
                loadingView.removeFromSuperview()
            }
        }
    }
}
