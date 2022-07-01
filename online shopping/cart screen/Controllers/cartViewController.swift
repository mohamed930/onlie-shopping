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
        SubscrbieToResponse()
        FetchProduct()
        SubscribeToBackButtonAction()
    }
    
    func ConfiguretableView() {
        tableView.register(UINib(nibName: NibFileName, bundle: nil), forCellReuseIdentifier: NibFileName)
        
        tableView.rowHeight = CGFloat(265)
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
    
    func SubscrbieToResponse() {
        cartviewmodel.productsCarBehvaiourObserval.subscribe { [weak self] carts in
            guard let self = self else { return }
            guard let carts = carts.element else { return }
            let result = self.cartviewmodel.SetCartValues(cart: carts)
            
            self.QuantityLabel.text = "Quantity: " + String(result.y)
            self.totalLabel.text = "Total: " + String(result.x)
            self.taxLabel.text = "Tax 21%: " + String(round(21 * result.x) / 100)
        }.disposed(by: dispossebag)
    }
    
    func FetchProduct() {
        cartviewmodel.FetchDataOperation()
    }
    
    func SubscribeToBackButtonAction() {
        BackButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: dispossebag)
    }
    
}
