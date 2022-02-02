//
//  SingleViewModel.swift
//  Practice_RxSwift
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SingleViewModel {
    var isLoading: PublishSubject<Bool> { get }
    var models: BehaviorRelay<[SingleStruct]> { get }
    
    func update()
}

class SingleViewModelImp: SingleViewModel {
    
    var isLoading: PublishSubject<Bool>
    var models: BehaviorRelay<[SingleStruct]> { repo.dataSources }
    
    private var repo: SingleRepository
    private var bag: DisposeBag
    
    init(
        repo: SingleRepository
    ) {
        self.bag = DisposeBag()
        self.isLoading = .init()
        self.repo = repo
        
    }
    
    func update() {
        self.isLoading.onNext(true)
        
        repo.fetch().subscribe { event in
            self.isLoading.onNext(false)
        }.disposed(by: bag)
    }
}
