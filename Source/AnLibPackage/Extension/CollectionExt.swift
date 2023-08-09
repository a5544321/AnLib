//
//  CollectionExt.swift
//  AnLib
//
//  Created by Andy on 2022/11/25.
//

import Foundation

extension Array {
    public mutating func safeInsert(_ newElement: Element, index: Int) {
        if index < count {
            insert(newElement, at: index)
        } else {
            append(newElement)
        }
    }
}
