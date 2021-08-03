//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/29.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoDetailViewModel!
    @IBOutlet weak var listTableVIew: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func bindViewModel() {
        
    }
}
