//
//  MainViewController.swift
//  Practice_RxSwift
//
//  Created by kimjiseob on 11/06/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    
    enum Source: CaseIterable {
        case signUp
        case geoLocation
        case githubSignUp
        case simpleTable
        case single
        
        var title: String {
            switch self {
            case .signUp:
                return "Sign Up"
            case .geoLocation:
                return "Geo Location"
            case .githubSignUp:
                return "Github Sign Up"
            case .simpleTable:
                return "Simple Table"
            case .single:
                return "Single"
            }
        }
        
        var segueID: String? {
            switch self {
            case .signUp:
                return "ShowSIgnUp"
            case .geoLocation:
                return "ShowGeoLocation"
            case .githubSignUp:
                return "ShowGithubSignUp"
            case .simpleTable:
                return "ShowSimpleTable"
            case .single:
                return "ShowSingle"
            }
        }
    }
    
    var disposeBag = DisposeBag()
    
    var tempView: UIView!
    private var bag = DisposeBag()
    private var dataSource: [Source] = Source.allCases
    
    private let cellID: String = "cell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "RxSwift"
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
    
    private func setTableView() {
        let ob = Observable.just(self.dataSource)
        ob.bind(to: tableView.rx.items(cellIdentifier: cellID)){ (row: Int, data: Source, cell: UITableViewCell) in
            var config = cell.defaultContentConfiguration()
            config.text = data.title
            
            cell.contentConfiguration = config
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
        }.disposed(by: bag)
        
        tableView.rx
            .modelSelected(Source.self)
            .filter{$0.segueID != nil}
            .map{$0.segueID!}
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { segueID in
                self.performSegue(withIdentifier: segueID, sender: nil)
            }).disposed(by: bag)
    }
}

// MARK: - 있던 메소드들
extension MainViewController {
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
        Observable<Int>.interval(.seconds(3), scheduler: MainScheduler.asyncInstance).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
}
