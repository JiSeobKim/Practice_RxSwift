//
//  GeoViewController.swift
//  Practice_RxSwift
//
//  Created by kimjiseob on 13/06/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GeoViewController: UIViewController {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var btnOpenSetting: UIButton!
    
    var disposeBag = DisposeBag()
    
    var isOn = false
    var lb1Text: String {
        get {
            let onText = "It seems that \n geolocation is enabled "
            let offText = "Geolocation is not\nenabled for this app"
            return (self.isOn == true ? onText : offText)
        }
    }
    
    var lb2Text: String {
        get {
            let onText = "Lat: \(resultValue.lat)\nLng: \(resultValue.lng)"
            let offText = "It seems that \n geolocation is enabled"
            return (self.isOn == true ? onText : offText)
        }
    }
    
    var resultValue: (lat: Double, lng: Double) = (0,0)
    
    var geoLocationUtils: GeoLocationUtils?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        btnOpenSetting.layer.cornerRadius = 5
        
        self.geoLocationUtils = GeoLocationUtils()
        
        self.geoLocationUtils?.authorized.subscribe(onNext: { (isOn) in
            self.isOn = isOn
            self.setUI()
        }).disposed(by: disposeBag)
        
        self.geoLocationUtils?
            .authorized
            .map{!$0}
            .bind(to: self.lb3.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.btnOpenSetting.rx.tap.subscribe { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
        }.disposed(by: disposeBag)
        
        self.geoLocationUtils?.location.subscribe(onNext: { (value) in
            self.resultValue = (value.latitude, value.longitude)
            self.lb2.text = self.lb2Text
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.geoLocationUtils = nil
    }
    
    /// set UI
    func setUI() {
        self.lb1.text = self.lb1Text
        self.lb2.text = self.lb2Text
        lb1.textColor = isOn ? .lightGray : .orange
    }
    
}

