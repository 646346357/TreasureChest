//
//  QWRXCocoaViewController.swift
//  ForSwift
//
//  Created by qinwen on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import JFPopup
import RxRelay

class QWRXCocoaViewController: QWBaseViewController {
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controlEventTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
//MARK: 特征序列（Traits）
    ///特征序列-Driver
    func driverTest() {
//        不会产生 error 事件
//        一定在主线程监听（MainScheduler）
//        共享状态变化（shareReplayLatestWhileConnected）
        let query = UITextField(frame: CGRect(x: 20, y: 100, width: view.jf_width-40, height: 40))
        query.borderStyle = .roundedRect

        let label1 = UILabel(frame: CGRect(x: 20, y: 160, width: view.jf_width-40, height: 20))
        let label2 = UILabel(frame: CGRect(x: 20, y: 200, width: view.jf_width-40, height: 20))
        view.addSubview(query)
        view.addSubview(label1)
        view.addSubview(label2)
        
        
        let results = query.rx.text.asDriver().throttle(RxTimeInterval.milliseconds(300)).flatMapLatest {[weak self] text in
            self!.fetchAutoCompleteItems(text: text ?? "").asDriver(onErrorJustReturn: "error")
        }

        results.map {
            "\($0)" + "---label1"
        }.drive(label1.rx.text).disposed(by: bag)
        
        results.map {
            "\($0)" + "---label2"
        }.drive(label2.rx.text).disposed(by: bag)
    }
    
    func fetchAutoCompleteItems(text: String) -> Observable<String> {
        return Observable.just(text)
    }
    
    
    ///特征序列-ControlProperty
    func controlPropertyTest() {
//        不会产生 error 事件
//        一定在 MainScheduler 订阅（主线程订阅）
//        一定在 MainScheduler 监听（主线程监听）
//        共享状态变化
        let query = UITextField(frame: CGRect(x: 20, y: 100, width: view.jf_width-40, height: 40))
        query.borderStyle = .roundedRect

        let label = UILabel(frame: CGRect(x: 20, y: 160, width: view.jf_width-40, height: 20))
        view.addSubview(query)
        view.addSubview(label)
        
        query.rx.text.bind(to: label.rx.text).disposed(by: bag)
        
    }
    
    ///特征序列-ControlEvent
    func controlEventTest() {
//        不会产生 error 事件
//        一定在 MainScheduler 订阅（主线程订阅）
//        一定在 MainScheduler 监听（主线程监听）
//        共享状态变化
        let btn = UIButton(frame: CGRect(x: 20, y: 100, width: view.jf_width-40, height: 40))
        btn.backgroundColor = .gray
        btn.setTitle("请点击", for: .normal)
        view.addSubview(btn)

        btn.rx.tap.subscribe(onNext: {
            print("点击了按钮")
        }).disposed(by: bag)
        
    }
    
    
    override func writeNote() {
        super.writeNote()

    }
}


