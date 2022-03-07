//
//  ProfileViewController.swift
//  OutstagramApp
//
//  Created by HyeonSoo Kim on 2022/03/06.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    var imageArr = [UIImage]()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40.0
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bright_Hyeon"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "18.08.18 ~ 김현수린 ing ♥︎"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0 //default가 1임.
        
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .systemBlue
        
        button.layer.cornerRadius = 3.0
        
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("메시지", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = .systemBackground
        
        button.layer.cornerRadius = 3.0
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        return button
    }()
    //why? private lazy var는 안하고 private let으로 해야하지?
    private let photoDataView = ProfileDataView(title: "게시물", count: 85)
    private let followerDataView = ProfileDataView(title: "팔로워", count: 252)
    private let followingDataView = ProfileDataView(title: "팔로잉", count: 237)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5 //line별 간격
        layout.minimumInteritemSpacing = 0.5 //같은 row의 item별 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigaionBar()
        
        setupLayout()
        
        //observer 설치.
        NotificationCenter.default.addObserver( //TODO: - NotificationCenter가 이 view가 load된 시점에 설치되기 때문에 현재 이 화면을 띄운적이 있어야만 추가가되는 상황. 추후 수정바람. //UserDefaults이용하려했으나, 구조체가 아닌 데이터를 저장하는 법에 아직 미숙. 또한 userdefaults는 큰 데이터를 저장하는데는 적합하지않다는 stackoverflow의 글을 읽음.
            self,
            selector: #selector(sendImageNotification(_:)),
            name: NSNotification.Name("sendImage"),
            object: nil
        )
    }
    
    @objc private func sendImageNotification(_ notification: Notification) {
        guard let image = notification.object as? UIImage else { return }
        //TODO: - uuidString사용하면 Profile collectionView 외에 다른 즐겨찾기 항목 등도 동시 구현가능할 것!
        self.imageArr.append(image)
        self.collectionView.reloadData()
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setup(with: imageArr[indexPath.row])
        //TODO: - 피드 셀들 최근 순서가 가장 첫번째에 위치하는 기능 구현하기.
        
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    //거의 필수로 쓰는 sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 1.0
        return CGSize(width: width, height: width)
    }
}

private extension ProfileViewController {
    func setupNavigaionBar() {
        navigationItem.title = "Swiftist"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(tapTabBarItem)
        )
    }
    
    @objc func tapTabBarItem() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let changeInfoButton = UIAlertAction(title: "회원 정보 변경", style: .default, handler: nil)
        let withdrawButton = UIAlertAction(title: "탈퇴하기", style: .destructive, handler: nil) //.destructive - 글씨 자동 빨강
        let closeButton = UIAlertAction(title: "close", style: .cancel, handler: nil) //.cancel - 자동으로 따로 빠짐.
        
        [changeInfoButton, withdrawButton, closeButton].forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func setupLayout() {
        //stackView를 이 함수안에서 묶는 것도 괜찮은 듯. 가독성.
        let buttonStackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        buttonStackView.spacing = 4.0
        buttonStackView.distribution = .fillEqually //subview 넓이 같도록.
        
        let dataStackView = UIStackView(arrangedSubviews: [photoDataView, followerDataView, followingDataView])
        dataStackView.spacing = 4.0
        dataStackView.distribution = .fillEqually
        
        [
            profileImageView, dataStackView, nameLabel, descriptionLabel, buttonStackView, collectionView
        ].forEach { view.addSubview($0) }
        
        let inset: CGFloat = 16.0 //반복적인 inset크기의 경우 상수로 설정하기.
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(inset) //지금 superView는 화면전체이다. 그래서 equalToSuperView()를 하게되면 safeArea도 넘어가기에 safeAreaLayoutGuide의 top과 맞춰주기. tableView는 안넘어가든데 이건 슥 넘어가부리네...
            $0.leading.equalToSuperview().inset(inset)
            $0.width.equalTo(80.0)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        dataStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(inset)
            $0.trailing.equalToSuperview().inset(inset)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12.0)
            $0.leading.equalTo(profileImageView.snp.leading)
            $0.trailing.equalToSuperview().inset(inset)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6.0)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(16.0)
            $0.bottom.equalToSuperview()
        }
    }
}
