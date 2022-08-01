//
//  PopInputViewController.swift
//  AnLibraryDemo
//
//  Created by Andy on 2022/5/27.
//

import UIKit
import AnLib

class PopInputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(String(describing: type(of: self)))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onShowDefaultClicked(_ sender: Any) {
        let view: AnPopInputView = AnPopInputView(title: "Enter", message: "Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message ")
        view.showIn(view: self.view)
        view.onClickOK = { message in
            print(message)
        }
        
    }
    
    @IBAction func onShowCustomClicked(_ sender: Any) {
        let view: CustomPopupInputView = CustomPopupInputView(title: "Enter", message: "Custom")
        view.verticleRate = 1
        view.showIn(view: self.view)
        view.onClickOK = { message in
            print(message)
        }
    }
    
    @IBAction func onShowAlertClicked(_ sender: Any) {
        let view = ImageAlertView(title: "Image", message: "Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok ")
        
        view.showIn(view: self.view)
    }
    
    @IBAction func onShowToastClicked(_ sender: Any) {
        let view = AnToastView(title: "Title Title ", message: "message message message message message", image: UIImage(systemName: "checkmark.circle"), length: .long)
        view.setImageColor(color: .green)
        view.setTitleTextColor(color: .red)
        view.showIn(view: self.view)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
