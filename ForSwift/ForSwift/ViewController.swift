//
//  ViewController.swift
//  ForSwift
//
//  Created by qinwen on 2022/10/6.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    private let bag = DisposeBag()
    lazy var tableView = UITableView(frame: view.bounds).then{
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.addSubview(tableView)
        rxBind()
    }
    
    private func rxBind() {
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "cell")){_,model,cell in
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textColor = .darkText
            cell.textLabel?.text = model.desc
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Model.self).subscribe(onNext: {[weak self] model in
            guard let self = self else {return}
            let cls = model.cls
            let vc = cls.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: bag)

    }
}

struct Model {
    let cls: UIViewController.Type
    let desc: String
}

struct ViewModel {
    let data = Observable.just([
        Model(cls: QWRXSwiftViewController.self, desc: "RXSwift"),
        Model(cls: QWRXCocoaViewController.self, desc: "RXCocoa"),
    ])
    
  
}
