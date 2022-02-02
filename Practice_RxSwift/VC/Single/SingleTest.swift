//
//  SingleTest.swift
//  Practice_RxSwiftTests
//
//  Created by 김지섭 on 2022/02/02.
//  Copyright © 2022 kimjiseob. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift

@testable import Practice_RxSwift

class SingleTest: XCTestCase {
    var sut: SingleViewModel!
    var queue: DispatchQueue!
    
    override func setUp() {
        queue = DispatchQueue.main
        sut = SingleViewModelImp(queue: queue)
    }
    
    func testSuccess() {
        // given, when
        let last = try? sut.createSingleSuccess()
            .toBlocking(timeout: 2)
            .last()
        
        // then
        XCTAssertEqual(last, "Hi")
    }
    
    func testFailure() {
        // given, when
        let last = try? sut.createSingleError()
            .toBlocking(timeout: 5)
            .last()
        
        // then
        XCTAssertNil(last)
    }
}
