//
//  cartViewController.swift
//  online shopping
//
//  Created by Mohamed Ali on 28/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol CountdataPassBack {
    func FetchtotalCount(totalCount: String)
}

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
    var flag = false
    var totalAmount = ""
    var delegate: CountdataPassBack?

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfiguretableView()
        SubscribeToTableView()
        SubscrbieToResponse()
        FetchProduct()
        SubscribeToBackButtonAction()
        SubscribeToDeleteResponse()
        SubscribeToConfirmOrderButtonAction()
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
            
            cell.incerementButtonObserval.subscribe(onNext: { [weak self] _ in
                let count = self?.cartviewmodel.incrementAmountOperation(ob: branch, operation: "+")
                cell.productamountLabel.text = String(count!)
                self?.flag = true
            }).disposed(by: self.dispossebag)
            
            cell.decerementButtonObserval.subscribe(onNext: { [weak self] _ in
                let count = self?.cartviewmodel.incrementAmountOperation(ob: branch, operation: "-")
                cell.productamountLabel.text = String(count!)
                self?.flag = true
            }).disposed(by: self.dispossebag)
            
        }.disposed(by: dispossebag)
    }
    
    func SubscrbieToResponse() {
        
        cartviewmodel.totalBehaviourObservsl.subscribe(onNext: { [weak self] total in
            guard let total = total else { return }
            guard let self = self else { return }
            
            self.totalAmount = total.productAmount
            
            self.QuantityLabel.text = "Quantity: " + total.productAmount
            self.totalLabel.text = "Total: " + total.totalAmount
            self.taxLabel.text = "Tax 21%: " + total.taxAmount
            
        }).disposed(by: dispossebag)
    }
    
    func FetchProduct() {
        cartviewmodel.FetchDataOperation()
    }
    
    func SubscribeToBackButtonAction() {
        BackButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            print("F: \(self.flag)")
            if self.flag {
                self.delegate?.FetchtotalCount(totalCount: self.totalAmount)
            }
            
            self.dismiss(animated: true)
        }).disposed(by: dispossebag)
    }
    
    func SubscribeToDeleteResponse() {
        cartviewmodel.confirmationBehaviour.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            guard let response = response else { return }
            
            if response {
                let story = UIStoryboard(name: "finish", bundle: nil)
                let nextVc = story.instantiateViewController(withIdentifier: "finishViewController") as! finishViewController
                nextVc.modalPresentationStyle = .fullScreen
                
                self.present(nextVc, animated: true)
            }
            else {
                print("Error")
            }
        }).disposed(by: dispossebag)
    }
    
    func SubscribeToConfirmOrderButtonAction() {
        OrderButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.cartviewmodel.RemoveAllproducts()
        }).disposed(by: dispossebag)
    }
    
}
