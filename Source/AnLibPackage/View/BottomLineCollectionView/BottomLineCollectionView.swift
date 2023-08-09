//
//  BottomLineCollectionView.swift
//  AnLibDemo
//
//  Created by Andy on 2023/1/13.
//

import UIKit

public protocol BottomLineCollectionViewDelegate: AnyObject {
    func didSelectItem(collectionView: UICollectionView, indexPath: IndexPath)
}
open class BottomLineCollectionView: UICollectionView {

    @IBInspectable var lineColor: UIColor = .systemPink
    @IBInspectable var lineWidth: CGFloat = 3.0
    @IBInspectable var padding: CGFloat = 16
    @IBInspectable var fontSize: CGFloat = 14
    @IBInspectable var textColor: UIColor = .white
    public weak var customDelegate: BottomLineCollectionViewDelegate?
    private var underLine: UIView?
    var items: [String] = []
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        internalInit()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        internalInit()
    }
    
    public func setItems(items: [String]) {
        self.items = items
        reloadData()
        updateUnderLine(indexPath: IndexPath(row: 0, section: 0), animate: false)
    }
    
    private func internalInit() {
//        collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        underLine = UIView(frame: .zero)
        underLine?.backgroundColor = lineColor
        addSubview(underLine!)
        self.delegate = self
        self.dataSource = self
        
        register(UINib(nibName: "SimpleTextCell", bundle: Bundle(for: BottomLineCollectionView.self)), forCellWithReuseIdentifier: "cell")
    }
    
    func updateUnderLine(indexPath: IndexPath, animate: Bool = true) {
        let layout = collectionViewLayout.layoutAttributesForItem(at: indexPath)
        let rect = layout?.frame
        let duration = 0.2
        if animate {
            UIViewPropertyAnimator(duration: duration, curve: .easeOut) { [self] in
                underLine?.frame = CGRect(x: rect!.origin.x, y: rect!.height - lineWidth, width: rect!.width, height: CGFloat(lineWidth))
            }.startAnimation()
        } else {
            underLine?.frame = CGRect(x: rect!.origin.x, y: rect!.height - lineWidth, width: rect!.width, height: CGFloat(lineWidth))
        }
        
    }
    
}

extension BottomLineCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimpleTextCell
        cell.mainLabel.text = items[indexPath.item]
        cell.mainLabel.textColor = textColor
        cell.mainLabel.font = UIFont.systemFont(ofSize: fontSize)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateUnderLine(indexPath: indexPath)
        customDelegate?.didSelectItem(collectionView: self, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if underLine?.frame.isEmpty ?? false {
            updateUnderLine(indexPath: IndexPath(row: 0, section: 0), animate: false)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = items[indexPath.item]
        let w = s.width(withConstrainedHeight: collectionView.bounds.height, font: UIFont.systemFont(ofSize: fontSize)) + padding
        
        return CGSize(width: w, height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
