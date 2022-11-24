//
//  ViewController.swift
//  AnLibDemo
//
//  Created by Andy on 2022/5/27.
//

import UIKit
import AnLib

class ViewController: UIViewController {
    @IBOutlet weak var mSlider: CenterOriginSlider!
    let ev = [-1, -0.66, -0.33, 0, 0.33, 0.66, 1]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        crop.image = UIImage(named: "")
        LogUtil.initialized()
        mSlider.addTarget(self, action: #selector(onSliderValChanged(sender:event:)), for: .valueChanged)
    }

    
    @objc func onSliderValChanged(sender: UISlider, event: UIEvent) {
        print(sender.value)
        print(ev[Int(sender.value.rounded())])
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
                
            case .ended:
                print("endddddddddd")
                sender.value = sender.value.rounded()
            default:
                break
            }
        }
    }
    
}

