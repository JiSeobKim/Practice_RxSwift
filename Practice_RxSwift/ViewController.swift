//
//  ViewController.swift
//  Practice_RxSwift
//
//  Created by kimjiseob on 11/06/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import UIKit
import RxSwift


class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    var tempView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.testObservable()
//        self.testSubject()
//        testZip()
//        testInterval()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        testQueue()
    }
    
    func testObservable() {
        
        let stringSequence = Observable.just([1,3,2,4])
        let oddSequence = Observable.from([1,3,5,7,9])
        
        let _ = stringSequence.subscribe { (value) in
            print(value)
            }.disposed(by: disposeBag)
        
        let _ = oddSequence.subscribe { (value) in
            print(value)
        }
        
        Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        var count = 1
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { print("Intercepted:", $0) },
                onError: { print("Intercepted error:", $0) },
                onCompleted: { print("Completed")  })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        
    }

    
    func testSubject() {
        
        let publishSubject = PublishSubject<String>()
        
        publishSubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        publishSubject.onNext("wow")
        
        let btn = UIButton(frame: CGRect(x: 50, y: 250, width: 50, height: 50))
        btn.backgroundColor = .red
        
        self.view.addSubview(btn)
        
        
        btn.rx.tap.subscribe(onNext: { (_) in
            publishSubject.onNext("wow")
            btn.frame.origin.y += 10
            
            if btn.frame.origin.y == 300 {
                publishSubject.onCompleted()
            }
        }).disposed(by: disposeBag)
        
        
        let behaviorSubject = BehaviorSubject(value: [1,2,3])
        
        behaviorSubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        behaviorSubject.onNext([3,4,1,3])
        
        
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        
        replaySubject.onNext("1")
        replaySubject.onNext("2")
        replaySubject.onNext("35")
        
        replaySubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        replaySubject.onNext("5")
        print(">>>>")
        Observable.from([1,2,3]).subscribe{print($0)}.disposed(by: disposeBag)
        print(">>>>")
        Observable.of([1,2,3],[23]).subscribe{print($0)}.disposed(by: disposeBag)
        
    }
    
    
    func testZip() {
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject,intSubject) { (v1, v2) in
             return "\(v1) \(v2)"
            }
            .subscribe{ print($0)}
            .disposed(by: disposeBag)
        
        stringSubject.onNext("A")
        stringSubject.onNext("B")
        intSubject.onNext(1)
    }
    
    func testInterval() {
        Observable<Int>.interval(3, scheduler: MainScheduler.asyncInstance).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
    
    func testQueue() {
        self.tempView = UIView(frame: CGRect(x: 100, y: 300, width: 200, height: 200))
        self.tempView.backgroundColor = .red
        self.view.addSubview(tempView)
        
        
        let temp = UIView(frame: CGRect(x: 100, y: 300, width: 200, height: 200))
        temp.backgroundColor = .blue
        self.view.addSubview(temp)
        
        DispatchQueue.main.async {
            for row in 1...100 {
                print("\(row) ❤️")
            }
        }

        DispatchQueue.global().async {
            for row in 1...100 {
                print("\(row) 😂")
            }
        }
        
        
        
        let sss = DispatchQueue(label: "Custom", attributes: .concurrent)
        let sss2 = DispatchQueue(label: "Custom2")

        sss.async {
            for row in 1...100 {
                print("\(row) 👿")
                self.tempView.frame.origin.y += 1
            }
        }





        sss2.sync {
            for row in 1...100 {
                print("\(row) ❤️")
            }
        }

        
        
        
        
        for row in 1...100 {
            print("\(row)")
        }
        
        
////
////        DispatchQueue.global().async {
////            for row in 1...10 {
////                print("\(row) 🥶")
////            }
////        }
////
//        DispatchQueue.global().sync {
//            for row in 1...100 {
//                print("\(row) ❤️")
//            }
//        }
//
//        DispatchQueue.global(qos: .userInteractive).sync {
//            for row in 1...100 {
//                print("\(row) 👹")
//            }
//        }
//
//
        
        
//        let customQueue = DispatchQueue(label: "Custom",qos: .userInteractive, attributes: .concurrent)
//
//        customQueue.async {
//            for row in 1...10 {
//                print("\(row) 😡")
//            }
//        }
//
//        for row in 201...210 {
//            print("\(row) 😇")
//        }
    }

}

