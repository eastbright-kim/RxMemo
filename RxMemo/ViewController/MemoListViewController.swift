//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/29.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoListViewModel!
    @IBOutlet weak var listTableVIew: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.memoList
            .bind(to: listTableVIew.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        
        Observable.zip(listTableVIew.rx.modelSelected(Memo.self), listTableVIew.rx.itemSelected)
            .do(onNext:{[unowned self] _ , indexPath in listTableVIew.deselectRow(at: indexPath, animated: true)})
            .map{$0.0}
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
        
        
        listTableVIew.rx.modelDeleted(Memo.self)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
    }

}
