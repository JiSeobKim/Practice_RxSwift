//
//  GitHubSignUpViewController.swift
//  Practice_RxSwift
//
//  Created by kimjiseob on 13/06/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubSignUpViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfPassR: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    
    var dp = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let notEmpty1 = tfName.rx.text.orEmpty.map{ $0.count > 0 }.share(replay:1)
        let notEmpty2 = tfPass.rx.text.orEmpty.map{ $0.count > 0 }.share(replay:1)
        let notEmpty3 = tfPassR.rx.text.orEmpty.map{ $0.count > 0 }.share(replay:1)
        
        let totalEmpty = Observable.combineLatest(notEmpty1, notEmpty2, notEmpty3){ $0 && $1 && $2 }
        totalEmpty.do(onNext: { (value) in
            switch value {
            case true:
                self.btnSignUp.backgroundColor = .red
            case false:
                self.btnSignUp.backgroundColor = .lightGray
            }
            }).bind(to: btnSignUp.rx.isEnabled).disposed(by: dp)
        
        

        // Do any additional setup after loading the view.
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
