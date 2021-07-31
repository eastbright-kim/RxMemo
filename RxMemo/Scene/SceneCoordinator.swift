//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/31.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    
    private let bag = DisposeBag()
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    @discardableResult
    func transition(to scene: Scene, using style: TrainsitionStyle, animated: Bool) -> Completable {
        
        let target = scene.instantiate()

        return Completable.create { [unowned self] completable in

            switch style {
            case .root:
                currentVC = target
                window.rootViewController = target
                completable(.completed)
            case .push:
                //푸시는 네비게이션 컨트롤러에 임베드 되어 있어야 의미가 있음
                guard let nav = currentVC.navigationController else {
                    completable(.error(TransitionError.navigationControllerMissing))
                    return Disposables.create {}
                }
                nav.pushViewController(target, animated: animated)
                currentVC = target
                completable(.completed)
            case .modal:
                currentVC.present(target, animated: animated) {
                    completable(.completed)
                }
                currentVC = target
            }

            return Disposables.create{}
        }
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            //뷰컨트롤러가 모달 방식으로 표시되어 있다면 현재 씬을 디스미스한다
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.navigationControllerMissing))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create {}
        }
    }
}
