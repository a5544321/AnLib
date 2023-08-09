//
//  CGExtension.swift
//  AnLib
//
//  Created by Andy on 2023/8/9.
//

import Foundation

public extension CGPoint {
    func midPoint(to: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + (to.x - self.x) * 0.5, y: self.y + (to.y - self.y) * 0.5)
    }
}
