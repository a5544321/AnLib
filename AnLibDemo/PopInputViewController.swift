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
        let view: AnPopInputView = AnPopInputView(message: "Enter")
        view.showIn(view: self.view)
        view.onClickOK = { message in
            print(message)
        }
        
    }
    
    @IBAction func onShowCustomClicked(_ sender: Any) {
        let view: CustomPopupInputView = CustomPopupInputView(message: "Custom")
        
        view.showIn(view: self.view)
        view.onClickOK = { message in
            print(message)
        }
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
