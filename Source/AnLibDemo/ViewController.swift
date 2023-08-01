//
//  ViewController.swift
//  AnLibDemo
//
//  Created by Andy on 2022/5/27.
//

import UIKit
import AnLib

class ViewController: UIViewController, BottomLineCollectionViewDelegate, UITextViewDelegate {
    
    
    
    @IBOutlet weak var bCollectionView: BottomLineCollectionView!
    
    @IBOutlet weak var mSlider: CenterOriginSlider!
    
    @IBOutlet weak var mTextview: UITextView!
    
    
    let ev = [-1, -0.66, -0.33, 0, 0.33, 0.66, 1]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        crop.image = UIImage(named: "")
        LogUtil.initialized()
        mSlider.addTarget(self, action: #selector(onSliderValChanged(sender:event:)), for: .valueChanged)
        
        
        bCollectionView.setItems(items: ["123123123","afsdfdqsfioahdsofiuh","afsdfdqsfioahdsofiuh","afsdfdqsfioahdsofiuh","afsdfdqsfioahdsofiuh","afsdfdqsfioahdsofiuh","afsdfdqsfioahdsofiuh","afsdfdqsfioahdsofiuh"])
        bCollectionView.customDelegate = self
        
        
        mTextview.addLink(url: "https://www.google.com", string: "google")
        mTextview.addLink(url: "https://tw.yahoo.com", string: "12345")
        mTextview.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    func didSelectItem(collectionView: UICollectionView, indexPath: IndexPath) {
        print(indexPath)
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

