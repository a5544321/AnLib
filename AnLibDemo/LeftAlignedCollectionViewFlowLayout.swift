//
//  LeftAlignedCollectionViewFlowLayout.swift
//  YouPerfect
//
//  Created by Andy on 2020/8/6.
//  Copyright © 2020 CL. All rights reserved.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    required init?(coder: NSCoder) {
        super.init()
        self.scrollDirection = .horizontal
    }
    override init() {
        super.init()
        self.scrollDirection = .horizontal
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        
        leftMargin += rect.origin.x
        
//        print(sectionInset.left)
        print(rect.origin.x)
        
        
        attributes?.forEach { layoutAttribute in
            layoutAttribute.frame.origin.x = leftMargin
//            print(leftMargin)
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = self.layoutAttributesForElements(in: CGRect(x: 0, y: 0, width: 20000, height: 100))
        return attrs?[indexPath.item]
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

