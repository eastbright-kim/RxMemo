//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/31.
//

import Foundation
import RxSwift
//import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    
    private let bag = DisposeBag()
    private var window: UIWindow
    private var currentVC: UIViewController
    
    //여기 init이 아닌 required 인 이유
    required init(window: UIWindow) {
        self.window = window
        //rootVC가 없는 상탠데 뭐가 들어갈까 . 처음 생성시 기본적으로 있는 루트 뷰컨.
        currentVC = window.rootViewController!
    }
    @discardableResult
    func transition(to scene: Scene, using style: TrainsitionStyle, animated: Bool) -> Completable {
        //가야하는 타겟
        //뷰컨트롤러를 여기서 만듦
        let target = scene.instantiate()
        let subject = PublishSubject<Void>()
        
        switch style {
        case .root:
            
            guard let nav = target.navigationController else {
                fatalError()
            }
            
            currentVC = target
            window.rootViewController = nav
            
            subject.onCompleted()
        case .push:
            //푸시는 네비게이션 컨트롤러에 임베드 되어 있어야 의미가 있음
            //
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                fatalError()
            }
            nav.pushViewController(target, animated: animated)
            currentVC = target
            subject.onCompleted()
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target
        }
        return subject.ignoreElements().asCompletable()
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
