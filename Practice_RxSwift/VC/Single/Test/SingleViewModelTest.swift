//
//  SingleViewModelTest.swift
//  Practice_RxSwiftTests
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift

@testable import Practice_RxSwift

class SingleViewModelTest: XCTestCase {
    private var sut: SingleViewModel!
    private var repo: SingleRepository!
    private var bag: DisposeBag!
    
    override func setUp() {
        repo = SingleRepositoryMock()
        sut = SingleViewModelImp(repo: repo)
        bag = DisposeBag()
    }
    
    func testUpdateModel() {
        // given
        let exp = expectation(description: "exp")
        
        var list: [SingleStruct] = []
        sut.models
            .skip(1)
            .subscribe(onNext: { data in
                list = data
                exp.fulfill()
            }).disposed(by: bag)
        
        // when
        sut.update()
        
        wait(for: [exp], timeout: 3)
        
        // then
        XCTAssertGreaterThan(list.count, 0)
    }
}
