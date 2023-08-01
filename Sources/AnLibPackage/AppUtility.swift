//
//  AppUtility.swift
//  AnLib
//
//  Created by Andy on 2023/8/1.
//

import Foundation
import UIKit


public struct AppUtility {
    
    public static var orientationLock = UIInterfaceOrientationMask.portrait
    
    /// return orientationLock in AppDelegate application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
    public static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        orientationLock = orientation
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    public static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
