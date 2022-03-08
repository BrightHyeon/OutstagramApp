//
//  UploadViewController.swift
//  OutstagramApp
//
//  Created by HyeonSoo Kim on 2022/03/07.
//

import UIKit
import SnapKit
import MapKit

final class UploadViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            print("나 이미지 받았어 !")
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        
        setupLayout()
        
        self.imageView.image = image!
        
        print("UploadViewControlelr 로드 !")
        print(image)
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
        //추후 UserDefaults 해보기.
        //delegate패턴 이용해보기.
        let profileVC = ProfileViewController()
        if let image = image {
            if profileVC.imageArr == nil {
                profileVC.imageArr = [image]
            } else {
                profileVC.imageArr?.append(image)
            }
        }
        print("난 분명히 눌렸어!")
        print(image)
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

