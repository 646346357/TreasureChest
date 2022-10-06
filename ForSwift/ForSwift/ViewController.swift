//
//  ViewController.swift
//  ForSwift
//
//  Created by qinwen on 2022/10/6.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
    lazy var dataList = [(QWBaseViewController.self, "测试一下")]
    lazy var tableView = UITableView(frame: view.bounds).then{
        $0.delegate = self
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cls = dataList[indexPath.row].0
        let vc = cls.init()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "reuseIdentifier"
        var cell = tableView .dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.selectionStyle = .none
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textColor = .darkText
        }
        cell?.textLabel?.text = dataList[indexPath.row].1
        
        return cell!
    }
    
    
}

