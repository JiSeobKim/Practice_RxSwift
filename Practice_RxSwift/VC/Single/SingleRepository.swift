//
//  SingleRepository.swift
//  Practice_RxSwift
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import RxSwift
import RxRelay

struct SingleStruct {
    let title: String
}

protocol SingleRepository {
    var dataSources: BehaviorRelay<[SingleStruct]> { get }
    func fetch() -> Single<Void>
}

class SingleRepositoryImp: SingleRepository {
    var dataSources: BehaviorRelay<[SingleStruct]> = .init(value: [])
    
    func fetch() -> Single<Void> {
        let single = Single<Void>.create { single -> Disposable in
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
                var previousList = self.dataSources.value
                let data = SingleStruct(title: "No. \(previousList.count)")
                previousList.append(data)
                
                self.dataSources.accept(previousList)
                single(.success(()))
            }
            
            return Disposables.create()
        }
        return single
    }
}
