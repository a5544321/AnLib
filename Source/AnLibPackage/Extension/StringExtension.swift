//
//  StringExtension.swift
//  AnLib
//
//  Created by Andy on 2022/7/27.
//

import Foundation
import UIKit
public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func isValidEmail() -> Bool {
        let regularExpression = "^[A-Z0-9a-z._%+-]{1,64}@(?:[A-Z0-9a-z-]{1,63}\\.){1,125}[A-Za-z]{2,63}$"
        let validate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return validate.evaluate(with: self, substitutionVariables: nil)
    }
}
