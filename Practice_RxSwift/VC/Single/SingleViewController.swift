//
//  SingleViewController.swift
//  Practice_RxSwift
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import UIKit
import RxSwift
import Combine

class SingleViewController: UIViewController {
    
    private var bag = DisposeBag()
    
    var schedular: SchedulerType?
    private var viewModel: SingleViewModel = SingleViewModelImp(repo: SingleRepositoryImp())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func successAction(_ sender: UIButton) {
        viewModel.update()
    }
}
