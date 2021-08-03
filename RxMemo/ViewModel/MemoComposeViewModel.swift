//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/29.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoComposeViewModel: CommonViewModel {
    private let content: String?
    
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: "")
    }
    
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>?, cancelAction: CocoaAction? = nil) {
        self.content = content
        self.saveAction = Action<String, Void>{ input in
            //action이 전달되었다면 실제로 action을 실행하고 화면을 닫음
            if let action = saveAction {
                action.execute(input)
            }
            //action이 전달되지 않았다면 화면만 닫고 끝남
            return sceneCoordinator.close(animated: true).asObservable().map{_ in}
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute()
            }
            return sceneCoordinator.close(animated: true).asObservable().map{_ in}
        }
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
