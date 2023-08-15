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
    
    mutating func rotate(angle: Double) {
        self.x = (self.x) * cos(angle) - (self.y) * sin(angle)
        self.y = (self.x) * sin(angle) + (self.y) * cos(angle)
    }
    
    func rotatePoint(angle: Double) -> CGPoint {
        var result = CGPoint.zero;
        result.x = x * cos(angle) - y * sin(angle);
        result.y = x * sin(angle) + y * cos(angle);
        return result
    }
}

public extension Float {
    var toDegree: Float {
        return self * 180 / Float.pi
    }
    
    var toRadian: Float {
        return self / 180 * Float.pi
    }
}
