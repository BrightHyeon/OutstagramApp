//
//  UIButton+.swift
//  OutstagramApp
//
//  Created by HyeonSoo Kim on 2022/03/06.
//

//기존 UIKit에 있는 class의 helper method; extension을 만든경우, 보통 이렇게 따로 파일을 만드는 것이 관례이며, 파일이름을 지을 때 class + "+"를 붙이는 것이 관례이다.
import UIKit

extension UIButton {
    //메서드 재정의! 버튼 속성 정의! button.content~, button.imageView.~~ 이렇게 들어가게됨.
    func setImage(systemName: String) {
        //정렬
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        //이미지 비율맞고 딱 차게
        imageView?.contentMode = .scaleAspectFit
        //이미지 인셋 없이.
        imageEdgeInsets = .zero
        
        setImage(UIImage(systemName: systemName), for: .normal)
    }
}
