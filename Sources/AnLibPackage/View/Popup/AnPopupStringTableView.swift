//
//  AnPopupStringTableView.swift
//  AnLib
//
//  Created by Andy on 2022/8/4.
//

import Foundation
import UIKit

public class AnPopupStringTableView: AnPopupBasicView {
    @IBOutlet weak var mTableView: UITableView!
    var stringArray: Array<String>?
    var selectCallback: ((Int)->Void)?
    
    public func setArray(array: Array<String>) {
        stringArray = array
        mTableView.reloadData()
    }
    
    public override func customInit() {
        super.customInit()
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    public func setSelectCallback(callback: @escaping ((Int)->Void)) {
        selectCallback = callback
    }
}

extension AnPopupStringTableView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stringArray?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = stringArray![indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCallback?(indexPath.row)
    }
    
    
}
