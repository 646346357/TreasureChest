//
//  QWBaseViewController.swift
//  ForSwift
//
//  Created by qinwen on 2022/10/6.
//

import UIKit
import RxSwift

class QWNoteViewController: UIViewController {
    private let note: String
    private let bag = DisposeBag()
    private lazy var noteView = UITextView().then{
        $0.text = note
        $0.font = .systemFont(ofSize: 15)
        $0.isEditable = false
    }
    
    init(note: String) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(noteView)
        
        noteView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(CGFloat.jf.navigationBarHeight())
        }
        
        noteView.addTapForView().subscribe{[weak self] _ in
            self?.dismiss(animated: true)
        }.disposed(by: bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
}

class QWBaseViewController: UIViewController {
    var note = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "笔记", style: .plain, target: self, action: #selector(openNote))
        writeNote()
    }
    
    @objc func openNote() {
        let vc = QWNoteViewController(note: note)
//        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func writeNote() {
        note.append(contentsOf: "内容：\n")
    }
}
