//
//  ImageAlertView.swift
//  AnLibDemo
//
//  Created by Andy on 2022/7/27.
//

import UIKit
import AnLib

class ImageAlertView: AnPopupBasicView{
    @IBOutlet weak var mImageView: UIImageView?

    public convenience init(title: String?, message: String?, image: UIImage?) {
        self.init(title: title, message: message)
        mImageView?.image = image
    }
}
