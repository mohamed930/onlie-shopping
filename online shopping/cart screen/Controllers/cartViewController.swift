//
//  cartViewController.swift
//  online shopping
//
//  Created by Mohamed Ali on 28/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class cartViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var OrderButton: UIButton!
    
    let cartviewmodel = cartViewModel()
    let dispossebag = DisposeBag()
    let NibFileName = "cartCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfiguretableView()
        SubscribeToTableView()
        FetchProduct()
    }
    
    func ConfiguretableView() {
        tableView.register(UINib(nibName: NibFileName, bundle: nil), forCellReuseIdentifier: NibFileName)
        
        tableView.rowHeight = CGFloat(255)
    }
    
    func SubscribeToTableView() {
        cartviewmodel.productsCarBehvaiourObserval.bind(to: tableView.rx.items(cellIdentifier: NibFileName, cellType: cartCell.self)) {[weak self] row , branch , cell in
            guard let self = self else { return }
            cell.CongfigureCell(cartporduct: branch)
            
            cell.nextImageButtonObserval.subscribe(onNext: { _ in
                self.cartviewmodel.scrollToNextCell(collectionView: cell.imagesCollectionView, action: "inc")
            }).disposed(by: self.dispossebag)
            
            cell.perviousImageButtonObserval.subscribe(onNext: { _ in
                self.cartviewmodel.scrollToNextCell(collectionView: cell.imagesCollectionView, action: "dec")
            }).disposed(by: self.dispossebag)
            
        }.disposed(by: dispossebag)
    }
    
    func FetchProduct() {
        cartviewmodel.FetchDataOperation()
    }
    
}
