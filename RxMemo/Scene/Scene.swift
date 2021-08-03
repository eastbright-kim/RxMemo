//
//  Scene.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/30.
//

import UIKit

enum Scene {
    
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
    
}

extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self {
        
        case .list(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var vc = nav.viewControllers.first as? MemoListViewController else { fatalError() }
            
            vc.bind(viewModel: viewModel)
            
            return vc
        case .compose(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var vc = nav.viewControllers.first as? MemoComposeViewController else { fatalError() }
            vc.bind(viewModel: viewModel)
            return nav
        case .detail(let viewModel):
            guard var vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
            vc.bind(viewModel: viewModel)
            return vc
        }
    }
}
