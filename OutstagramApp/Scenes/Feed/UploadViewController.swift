//
//  UploadViewController.swift
//  OutstagramApp
//
//  Created by HyeonSoo Kim on 2022/03/07.
//

import UIKit
import SnapKit

final class UploadViewController: UIViewController {

    private let image: UIImage
    
    private let imageView = UIImageView()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        //textField는 placeholder가 있지만 최대 한 줄. textView는 placeholder없어서 기능 만들어줘야함. delegate이용.
        textView.text = "문구 입력..."
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 15)
        textView.delegate = self
        
        return textView
    }()
    
    init(image: UIImage) {
        self.image = image
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        
        setupLayout()
        
        imageView.image = image
    }
}

extension UploadViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) { //editing이 시작되면 실행.
        guard textView.textColor == .secondaryLabel else { return } //문구가 회색일때만 코드 실행.
        
        textView.text = nil
        textView.textColor = .label
    }
}

private extension UploadViewController {
    func setupNavigationBar() {
        navigationItem.title = "새 게시물"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapLeftButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "공유",
            style: .plain,
            target: self,
            action: #selector(didTapRightButton)
        )
    }
    
    @objc func didTapLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapRightButton() {
        NotificationCenter.default.post( //TODO: 이방법쓰기전에 헛질 겁나했다... 단순 프로퍼티 접근은 push나 present등에서 화면이동하면서 한번에 데이터를 전달하는 것이기에 가능하나 이렇게 그 화면으로 가지 않는 경우 불가능...! 추후 더 공부하기!!!
            name: NSNotification.Name("sendImage"),
            object: image,
            userInfo: nil
        )
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupLayout() {
        [imageView, textView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(100)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(imageView)
        }
    }
}

