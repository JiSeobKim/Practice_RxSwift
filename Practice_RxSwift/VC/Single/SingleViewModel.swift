//
//  SingleViewModel.swift
//  Practice_RxSwift
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import RxSwift

protocol SingleViewModel {
    func createSingleSuccess() -> Single<String>
    func createSingleError() -> Single<String>
}

class SingleViewModelImp: SingleViewModel {
    
    enum TestError: Error {
        case test
    }
    
    private var queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    func createSingleSuccess() -> Single<String> {
        let single = Single<String>.create { single -> Disposable in
            
            self.queue.asyncAfter(deadline: .now() + 0.2) {
                single(.success("Hi"))
            }
            return Disposables.create()
        }
        
        return single
    }
    
    func createSingleError() -> Single<String> {
        let single = Single<String>.create { single -> Disposable in
            
            self.queue.asyncAfter(deadline: .now() + 0.5) {
                let error = NSError(domain: #function, code: 0, userInfo: nil)
                print(">> \(error)")
                single(.failure(error))
            }
            return Disposables.create()
        }
        return single
    }
}
