//
//  FeedViewController.swift
//  OutstagramApp
//
//  Created by HyeonSoo Kim on 2022/03/06.
//

import UIKit
import SnapKit

final class FeedViewController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary //소스타입: 어디서 가져올것인지. //이 메서드 -> iOS에서 곧 사라질 예정.
        imagePickerController.allowsEditing = true //확대, 위치이동 등 편집 기능 부여
        imagePickerController.delegate = self

        return imagePickerController
    }() //새로 생긴 PHPickerViewController 추후 공부하기.
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none //separator없도록.
        tableView.dataSource = self
        //custom cell 등록.
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupTableView()
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10 //지금 버전에선 굳이 return 안써줘도됨.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        //***이거 구글링으로도 못찾았는데...ㅠㅠ!!! cell이 select되지않도록 하는 코드!!! ***
        cell.selectionStyle = .none
        
        cell.setup()
        
        return cell
    }
}

//imagePicker를 통해 사진을 선택했을 때 실행되는 메서드인 didFinishPickingMediaWithInfo를 사용하려면,
//UIImagePickerControllerDelegate를 채택해야하고, 이 프로토콜을 이용하려면 반드시 UINavigationControllerDelegate 프로토콜도 동반되야한다.
extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //imagePicker의 edit화면에서 choose를 누른 후 실행되는 메서드. didFinishPickingMediaWithInfo.
        var selectImage: UIImage? //이미지를 받을 변수 선언.
        
        //info : 선택된 이미지의 정보를 가지고있는 딕셔너리(다중 선택이 가능하니, 딕셔너리형태인듯함.)
        //editing(편집)을 통해 가져온 이미지의 키 값은 editedImage임.
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImage = originalImage //편집 안된 그냥 원래이미지.
        }
        
        picker.dismiss(animated: true) { [weak self] in //present 아까 했으니, 상응하는 dismiss로! //강한순환참조 방지! self사용 및 클로저 속 클로저 등?
            //completion handler
            let imageView = UIImageView()
            imageView.image = selectImage
            
            let uploadViewController = UploadViewController(imageView: imageView)
            let navigationController = UINavigationController(rootViewController: uploadViewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            self?.present(navigationController, animated: true, completion: nil)
        }
    }
}

private extension FeedViewController {
    func setupNavigationBar() {
        navigationItem.title = "Outstagram"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.app"),
            style: .plain,
            target: self,
            action: #selector(tapTabBarButton)
        )
    }
    
    @objc func tapTabBarButton() {
        present(imagePickerController, animated: true, completion: nil)
    } //Apple심사는 까다롭다. 반드시 info.plist에서 Privacy - Photo Library Additions Usage Description을 만들어야함.

    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
