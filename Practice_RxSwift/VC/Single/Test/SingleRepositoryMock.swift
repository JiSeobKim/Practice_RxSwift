//
//  SingleRepositoryMock.swift
//  Practice_RxSwift
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import RxSwift
import RxCocoa

class SingleRepositoryMock: SingleRepository {
    var dataSources: BehaviorRelay<[SingleStruct]> = .init(value: [])
    var isSuccess = false
    
    var fetchCallCount = 0
    func fetch() -> Single<Void> {
        fetchCallCount += 1
        
        switch self.isSuccess {
        case true:
            let new = SingleStruct(title: "Test")
            self.dataSources.accept(dataSources.value + [new])
            return .just(())
        case false:
            return .error(NSError(domain: #function, code: 0, userInfo: nil))
        }
    }
}
