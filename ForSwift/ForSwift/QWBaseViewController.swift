//
//  QWBaseViewController.swift
//  ForSwift
//
//  Created by qinwen on 2022/10/6.
//

import UIKit

class QWNoteViewController: UIViewController {
    private let note: String
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
            $0.edges.equalToSuperview()
        }
    }
    
}

class QWBaseViewController: UIViewController {
    var note = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "笔记", style: .plain, target: self, action: #selector(openNote))
        note.append(contentsOf: "内容：\n")
    }
    
    @objc func openNote() {
        let vc = QWNoteViewController(note: note)
        present(vc, animated: true)
    }
}
