//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/31.
//

import Foundation
import RxSwift
import RxCocoa
//nsobject상속받고 있는 이유는?. 클래스 상속.
class CommonViewModel {
    let title: Driver<String>
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
    
}
