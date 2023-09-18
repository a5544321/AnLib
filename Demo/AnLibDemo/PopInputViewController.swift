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
        showActionView()
//        let view = AnAlertView(title: "Image", message: "Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok Are you ok ", image: UIImage(systemName: "questionmark.circle.fill"), popStyle: .bottomCard)
//
//        view.showIn(view: UIApplication.shared.keyWindow!)
        
//        let message = "Dashcam A (Standard plan)Dashcam A A"
//        let alert = AnAlertView(title: "Event Recordings", message: message, image: UIImage(systemName: "questionmark.circle.fill"), popStyle: .alert)
////        alert.setImageTintColor(color: UIColor(hex: "#6B6B6B"))
//        alert.setOKButton(title: "Got it", tintColor: .blue, isFill: true, action: nil)
//        alert.setCancelButton(title: "CCC", tintColor: .red, isFill: false, action: nil)
//        alert.showIn(view: UIApplication.shared.keyWindow!)
    }
    
    @IBAction func onShowToastClicked(_ sender: Any) {
        let view = AnToastView(title: "Title Title ", message: "We’re ready to ride a fantastic journey with you.", image: UIImage(systemName: "checkmark.circle"), position: .top, length: .long)
        view.setImageColor(color: .green)
//        view.setTitleTextColor(color: .red)
        view.showIn(view: self.view)
//        self.view.showToast(title: "Success!", style: .black)
    }
    
    
    func showActionView() {
        let view = AnActionAlertView(title: "ABDS", message: "Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message Enter message", image: UIImage(systemName: "checkmark.circle"), imageTintColor: .brown)
        view.addAction(title: "Action 1", mainColor: .blue, textColor: .white) { [weak self] button in
            print("1")
        }
        view.addAction(title: "Action 2", mainColor: .orange, textColor: .white) { [weak self] button in
            print("2")
        }
        view.addAction(title: "Action 3", mainColor: .blue, textColor: .black) { [weak self] button in
            print("3")
        }
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
