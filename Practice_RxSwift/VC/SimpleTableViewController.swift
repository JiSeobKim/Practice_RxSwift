//
//  SimpleTableViewController.swift
//  Practice_RxSwift
//
//  Created by kimjiseob on 14/06/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTableViewController: UIViewController {

    let value: [Int] = [Int](1...100)
    
    let dp = DisposeBag()
    
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tb.rx.itemAccessoryButtonTapped.subscribe { (event) in
            print(event.element?.row ?? 0)
        }.disposed(by: dp)
        
        tb.rx.itemSelected.subscribe { (event) in
            print(event.element?.row ?? 0)
        }.disposed(by: dp)
    }

}

extension SimpleTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .detailButton
        
        
        let text = "\(value[indexPath.row]) @ row \(indexPath.row)"
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = "Secret"
        
        return cell
    }
}
