//
//  SignUpViewController.swift
//  Practice_RxSwift
//
//  Created by kimjiseob on 11/06/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lbNmValidation: UILabel!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var lbpwValidation: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    let nameMinimum = 5
    let passMinimum = 5
    
    private let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nameValid = tfName.rx.text.orEmpty.map{ $0.count >= self.nameMinimum }.share(replay: 1)
        let passValid = tfPass.rx.text.orEmpty.map{$0.count >= self.passMinimum }.share(replay: 1)
        
    
        
        nameValid.bind(to: tfPass.rx.isEnabled).disposed(by: disposeBag)
        nameValid.bind(to: lbNmValidation.rx.isHidden).disposed(by: disposeBag)
        
        passValid.bind(to: btnDone.rx.isEnabled).disposed(by: disposeBag)
        passValid.bind(to: lbpwValidation.rx.isHidden).disposed(by: disposeBag)
        
        btnDone.rx.tap.subscribe { [weak self] _ in
            self?.actions()
        }.disposed(by: disposeBag)
      
    }
    
    func actions() {
        
        print("Done")
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
