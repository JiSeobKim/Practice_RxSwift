//
//  SinglePlayground.swift
//  Practice_RxSwift
//
//  Created by 김지섭 on 2022/02/03.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import RxSwift
import Foundation

class SinglePlayground {
    
    func test() {
        let single = getSingle()
        
        let single2 = Single<String>.create { closer -> Disposable in
            closer(.success("Temp"))
            
            return Disposables.create()
        }
        
        
        create { closer in
            
            DispatchQueue.global().async {
                closer(.success("Hi"))
            }
            return Disposables.create()
        }
        
    }
    
    var closerTest: (String)->() = { _ in
        
    }
    
    func getSingle() -> Single<String> {
        let single = Single.just("Hi")
        return single
    }
    
    public typealias SingleObserver = (SingleEvent<String>) -> Void
    
    func create(subscribe: @escaping (@escaping SingleObserver) -> Disposable) {
        temp {
            let a = subscribe { value in
                
                
            }
            
            return Disposables.create()
        }
    }
    
    func temp(subscribe: @escaping () -> Disposable) {
    }
}
