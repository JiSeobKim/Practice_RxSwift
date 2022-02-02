//
//  SingleRepositoryTest.swift
//  Practice_RxSwift
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Practice_RxSwift


class SingleRepositoryTest: XCTestCase {
    private var sut: SingleRepositoryImp!
    private var bag = DisposeBag()
    
    override func setUp() {
        sut = SingleRepositoryImp()
    }
    
    func testFetch() {
        // given
        // when
        _ = try? sut.fetch()
            .toBlocking(timeout: 2)
            .last()
        
        // then
        let count = sut.dataSources.value.count
        XCTAssertGreaterThan(count, 0)
    }
    
}

