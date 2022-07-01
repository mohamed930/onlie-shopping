//
//  productDetailsViewController.swift
//  online shopping
//
//  Created by Mohamed Ali on 25/06/2022.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

protocol representToHomeScreen {
    func sendToBack(flag: Bool,location: Int,count: Int,action: Bool)
}

class productDetailsViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productImagesCollectionView: UICollectionView!
    @IBOutlet weak var productImageCollectionViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    
    @IBOutlet weak var SizeView: UIView!
    @IBOutlet weak var SizeViewHight: NSLayoutConstraint!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var ColorViewHight: NSLayoutConstraint!
    @IBOutlet weak var ColorCollectionView: UICollectionView!
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var productDetailsLabel: WKWebView!
    
    @IBOutlet weak var AddCartButton: UIButton!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    let disposebag = DisposeBag()
    let productdetailsviewmodel = productDetailsViewModel()
    let nibFileName = "imageCell"
    let SizenibFileName = "sizeCell"
    var delegate: representToHomeScreen!
    let radiousValue = CGFloat(7)
    var productcount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        AddButton.AddCornerRadiour(radious: radiousValue)
        minusButton.AddCornerRadiour(radious: radiousValue)
        
        SubscribeToBackButton()
        subscribeToresponse()
        ConfigureImageCollectionView()
        SubscribeToImageCollectionView()
        SubscribeToSizeCollectionView()
        SubscribeToColorCollectionView()
        SubscribeToSelectImage()
        SubscribeToSelectSizeCollection()
        SubscribeToSelectColorCollection()
        SubscribeToSendToCartRespone()
        SubacribeToAddCartButtonAction()
        SubscribeToAddButtonAction()
        SubscribeTominusButtonAction()
        loadData()
    }
    
    func SubscribeToBackButton() {
        BackButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            var minus = false
            
            if (Int(self.countLabel.text!)! > self.productcount) {
                self.productcount = Int(self.countLabel.text!)! - self.productcount
                minus = true
                
            }
            else {
                self.productcount = self.productcount - Int(self.countLabel.text!)!
                minus = false
            }
            
            self.delegate.sendToBack(flag: true, location: self.productdetailsviewmodel.productLoactionBehaviour.value, count: self.productcount,action: minus)
            
            self.dismiss(animated: true)
            
        }).disposed(by: disposebag)
    }
    
    func subscribeToresponse() {
        productdetailsviewmodel.productDetailsBehaviourObserval.subscribe(onNext: { [weak self] productDetails in
            guard let self = self else { return }
            
            guard let productDetails = productDetails else { return }
            
            self.productNameLabel.text = productDetails.name
            self.productBrandLabel.text = productDetails.brand
            self.PriceLabel.text =  productDetails.prices[0].fragments.priceDetails.currency.symbol + String(productDetails.prices[0].fragments.priceDetails.amount)
            
            let header = """
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                        <style>
                            body {
                                font-family: "Roboto";
                                font-size: 24px;
                            }
                        </style>
                    </head>
                    <body style = "text-Alignment = "center">
                    """
            
            self.productDetailsLabel.loadHTMLString(header + productDetails.description + "</body>", baseURL: nil)
            
            DispatchQueue.main.async {
                guard let image = productDetails.gallery?[0] else {
                    self.productImageView.image = UIImage(named: "ProductImage")
                    return
                }
                
                self.productImageView.kf.setImage(with:URL(string: image.trimmingCharacters(in: .whitespaces) )!,placeholder: UIImage(named: "ProductImage"))
            }
            
            guard let images = productDetails.gallery else { return }
            
            if images.count > 1 {
                self.productImageCollectionViewHight.constant = 65
            }
            else {
                self.productImageCollectionViewHight.constant = 0
            }
            
            self.productdetailsviewmodel.imagesBehavriour.accept(images as! [String])
            
            guard let attribute = productDetails.attributes else { return }
            
            if attribute.isEmpty {
                self.ColorViewHight.constant = 0
                self.SizeViewHight.constant = 0
                self.SizeView.isHidden = true
                self.ColorView.isHidden = true
            }
            else {
                
                var FColor = false
                var FSize = false
                
                for i in attribute {
                    guard let i = i else { return }
                    
                    if i.fragments.attributeDetails.name == "Color" {
                        guard let items = i.fragments.attributeDetails.items else { return }
                        FColor = true
                        self.productdetailsviewmodel.ColorBehaviour.accept(items)
                        
                    }
                    else if i.fragments.attributeDetails.name == "Capacity" || i.fragments.attributeDetails.name == "Size" {
                        guard let items = i.fragments.attributeDetails.items else { return }
                        FSize = true
                        self.productdetailsviewmodel.sizeBehaviour.accept(items)
                    }
                }
                
                if !FColor {
                    self.ColorViewHight.constant = 0
                    self.ColorView.isHidden = true
                }
                
                if !FSize {
                    self.SizeViewHight.constant = 0
                    self.SizeView.isHidden = true
                }
            }
            
            
            if productDetails.inStock! {
                if self.productdetailsviewmodel.productInCartBehaviour.value {
                    self.AddCartButton.isHidden = true
                    self.countView.isHidden = false
                    guard let data = self.productdetailsviewmodel.productCartBehaviour.value else { return }
                    self.countLabel.text = String(data.count)
                    self.productcount = data.count
                }
                else {
                    self.AddCartButton.isHidden = false
                    self.countView.isHidden = true
                }
            }
            else {
                self.AddCartButton.isHidden = true
            }
            
            
        }).disposed(by: disposebag)
    }
    
    func ConfigureImageCollectionView() {
        
        productImagesCollectionView.register(UINib(nibName: nibFileName, bundle: nil), forCellWithReuseIdentifier: nibFileName)
        
        sizeCollectionView.register(UINib(nibName: SizenibFileName, bundle: nil), forCellWithReuseIdentifier: SizenibFileName)
        
        ColorCollectionView.register(UINib(nibName: SizenibFileName, bundle: nil), forCellWithReuseIdentifier: SizenibFileName)
        
        let flowlayout = FlowLayout(collectionView: productImagesCollectionView)
        let flowlayout2 = FlowLayout(collectionView: sizeCollectionView)
        let flowlayout3 = FlowLayout(collectionView: ColorCollectionView)
        
        productImagesCollectionView.collectionViewLayout = flowlayout
        sizeCollectionView.collectionViewLayout = flowlayout2
        
        flowlayout3.itemSize = CGSize(width: ColorCollectionView.frame.size.height, height: ColorCollectionView.frame.size.height)
        ColorCollectionView.collectionViewLayout = flowlayout3
    }
    
    private func FlowLayout(collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        var size = 0
        
        if self.view.frame.height == 667 {
            size = Int(((collectionView.frame.size.width - 10) / CGFloat(4)))
        }
        else if self.view.frame.height == 568 {
            size = Int((collectionView.frame.size.width / CGFloat(4)) - 5)
        }
        else {
            size = Int((collectionView.frame.size.width / CGFloat(4)) + 15)
        }
        
        flowLayout.itemSize = CGSize(width: size, height: Int(collectionView.frame.size.height - 10))
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        return flowLayout
    }
    
    func SubscribeToImageCollectionView() {
        productdetailsviewmodel.imagesBehavriour.bind(to: productImagesCollectionView.rx.items(cellIdentifier: nibFileName, cellType: imageCell.self)) { row, branch , cell in
            cell.configureCell(image: branch)
        }.disposed(by: disposebag)
    }
    
    func SubscribeToSizeCollectionView() {
        productdetailsviewmodel.sizeBehaviour.bind(to: sizeCollectionView.rx.items(cellIdentifier: SizenibFileName, cellType: sizeCell.self)) { [weak self] row, branch , cell in
            guard let self = self else { return }
            cell.ConfigureSizeCell(sizeNumber: (branch?.displayValue)!)
            
            guard let prodctData = self.productdetailsviewmodel.productCartBehaviour.value else { return }
            if prodctData.pickedSize != nil {
                if branch?.value == prodctData.pickedSize {
                    cell.sizeView.backgroundColor = UIColor().hexStringToUIColor(hex: "#1D1F22")
                    cell.sizeLabel.textColor = UIColor.white
                }
            }
        }.disposed(by: disposebag)
    }
    
    func SubscribeToColorCollectionView() {
        productdetailsviewmodel.ColorBehaviour.bind(to: ColorCollectionView.rx.items(cellIdentifier: SizenibFileName, cellType: sizeCell.self)) { [weak self] row, branch , cell in
            guard let self = self else { return }
            cell.ConfigureColorCell(colorCode: (branch?.value)!)
            
            guard let prodctData = self.productdetailsviewmodel.productCartBehaviour.value else { return }
            if prodctData.pickedColor != nil {
                if branch?.value == prodctData.pickedColor {
                    cell.sizeView.layer.borderColor = UIColor().hexStringToUIColor(hex: "#5ECE7B").cgColor
                    cell.sizeView.layer.borderWidth = 2
                }
            }
            
        }.disposed(by: disposebag)
    }
    
    func SubscribeToSelectImage() {
        Observable.zip(productImagesCollectionView.rx.itemSelected, productImagesCollectionView.rx.modelSelected(String?.self))
            .bind { [weak self] selectedIndex, branch in

                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let image = branch else {
                        self.productImageView.image = UIImage(named: "ProductImage")
                        return
                    }
                    
                    self.productImageView.kf.setImage(with:URL(string: image.trimmingCharacters(in: .whitespaces) )!,placeholder: UIImage(named: "ProductImage"))
                }
//                print(selectedIndex[1], branch.UserName)
        }
        .disposed(by: disposebag)
    }
    
    func SubscribeToSelectSizeCollection() {
        
        sizeCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexpath in
            guard let self = self else { return }
            
            let data = self.productdetailsviewmodel.sizeBehaviour.value
            
            if self.productdetailsviewmodel.productCartBehaviour.value != nil {
                self.productdetailsviewmodel.UpdateSizeOperation(data[indexpath.row]?.value ?? nil)
            }
            
            self.sizeCollectionView.visibleCells.forEach { cell in
                if let cell = cell as? sizeCell {
                    cell.sizeView.backgroundColor = UIColor.white
                    cell.sizeLabel.textColor = .black
                }
            }
            
            let cell = self.sizeCollectionView.cellForItem(at: indexpath) as? sizeCell
            
            self.productdetailsviewmodel.pickedSizeBehaviour.accept(data[indexpath.row]?.value ?? nil)
            
            cell?.sizeView.backgroundColor = UIColor().hexStringToUIColor(hex: "#1D1F22")
            cell?.sizeLabel.textColor = UIColor.white
            
        }).disposed(by: disposebag)
    }
    
    func SubscribeToSelectColorCollection() {
     
        ColorCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexpath in
            
            guard let self = self else { return }
            
            let data = self.productdetailsviewmodel.ColorBehaviour.value
            
            if self.productdetailsviewmodel.productCartBehaviour.value != nil {
                self.productdetailsviewmodel.UpdateColorOperation(data[indexpath.row]?.displayValue ?? nil)
            }
            
            self.ColorCollectionView.visibleCells.forEach { cell in
                if let cell = cell as? sizeCell {
                    cell.sizeView.layer.borderColor = UIColor.clear.cgColor
                }
            }
            
            let cell = self.ColorCollectionView.cellForItem(at: indexpath) as? sizeCell
            
            
            self.productdetailsviewmodel.pickedColorBehaviour.accept(data[indexpath.row]?.displayValue ?? nil)
            
            cell?.sizeView.layer.borderColor = UIColor().hexStringToUIColor(hex: "#5ECE7B").cgColor
            cell?.sizeView.layer.borderWidth = 2
            
        }).disposed(by: disposebag)
        
    }
    
    func SubscribeToSendToCartRespone() {
        productdetailsviewmodel.SavedResponseBehaviourObserval.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if response == "Success" {
                self.delegate.sendToBack(flag: true,location: self.productdetailsviewmodel.productLoactionBehaviour.value,count: 1, action: true)
                self.dismiss(animated: true)
            }
            else {
                print("Error in Saving \(response)")
                self.delegate.sendToBack(flag: false, location: 0,count: 0, action: false)
            }
        }).disposed(by: disposebag)
    }
    
    func SubacribeToAddCartButtonAction() {
        AddCartButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.productdetailsviewmodel.SaveDataToCart()
            
        }).disposed(by: disposebag)
    }
    
    func SubscribeToAddButtonAction() {
        AddButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            self.productdetailsviewmodel.AddAmountAction(self.countLabel, operation: "+")
        }).disposed(by: disposebag)
    }
    
    func SubscribeTominusButtonAction() {
        minusButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            self.productdetailsviewmodel.AddAmountAction(self.countLabel, operation: "-")
        }).disposed(by: disposebag)
    }
    
    func loadData() {
        productdetailsviewmodel.FetchproductDetailsOperation()
    }
}
