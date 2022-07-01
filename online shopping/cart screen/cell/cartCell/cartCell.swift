//
//  cartCell.swift
//  online shopping
//
//  Created by Mohamed Ali on 28/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class cartCell: UITableViewCell {
    
    @IBOutlet weak var porductNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var SizeCollectionView: UICollectionView!
    @IBOutlet weak var SizeView: UIView!
    @IBOutlet weak var ColorCollectionView: UICollectionView!
    @IBOutlet weak var ColorView: UIView!
    
    @IBOutlet weak var productamountLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var nextImageButton: UIButton!
    @IBOutlet weak var decrementImageButton: UIButton!
    
    let NibfileName = "imageCell"
    private let imagesBehaviour = BehaviorRelay<[String?]>(value: [])
    let SizeNibfileName = "sizeCell"
    private let sizesBehaviour = BehaviorRelay<[SizeModel]>(value: [])
    private let colorsBehaviour = BehaviorRelay<[SizeModel]>(value: [])
    let disposebag = DisposeBag()
    
    var nextImageButtonObserval : Observable<Void>{
        return self.nextImageButton.rx.tap.throttle(.milliseconds(1000), scheduler: MainScheduler.instance).asObservable()
    }
    
    var perviousImageButtonObserval : Observable<Void>{
        return self.decrementImageButton.rx.tap.throttle(.milliseconds(1000), scheduler: MainScheduler.instance).asObservable()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        ConfigureButton(incrementButton)
        ConfigureButton(decrementButton)
        
        ConfigureCollectionView()
        SubscribeToCollection()
        
        ConfigureSizeCollectionView()
        SubscribeToSizeCollection()
        
        ConfigureColorCollectionView()
        SubscribeToColorCollection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func CongfigureCell(cartporduct: productcartModel) {
        porductNameLabel.text = cartporduct.productName
        productBrandLabel.text = cartporduct.productBrand
        productPriceLabel.text = cartporduct.productPriceSynmbol + cartporduct.productPrice
        
        productamountLabel.text = cartporduct.productAmount
        
        imagesBehaviour.accept(cartporduct.produtsImage)
        if cartporduct.produtsImage.count <= 1 {
            nextImageButton.isHidden = true
            decrementImageButton.isHidden = true
        }
        else {
            nextImageButton.isHidden = false
            decrementImageButton.isHidden = false
        }
        
        
        if cartporduct.productSize?.count == 0 {
            SizeView.isHidden = true
        }
        else {
            // Configure Size CollectionView.
            guard let sizesArr = cartporduct.productSize else { return }
            sizesBehaviour.accept(sizesArr)
        }
        
        if cartporduct.procutColor?.count == 0 {
            ColorView.isHidden = true
        }
        else {
            // Configure Color CollecitonView.
            guard let colorsArr = cartporduct.procutColor else { return }
            colorsBehaviour.accept(colorsArr)
        }
    }
    
    private func ConfigureButton(_ button: UIButton) {
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
    }
    
    private func ConfigureCollectionView() {
        imagesCollectionView.register(UINib(nibName: NibfileName, bundle: nil), forCellWithReuseIdentifier: NibfileName)
        let flow = FlowLayout(width: imagesCollectionView.frame.size.width, hight: imagesCollectionView.frame.size.height - 10)
        imagesCollectionView.collectionViewLayout = flow
    }
    
    private func SubscribeToCollection() {
        imagesBehaviour.asObservable().bind(to: imagesCollectionView.rx.items(cellIdentifier: NibfileName, cellType: imageCell.self)) {row , branch , cell in
            cell.configureCell(image: branch)
            cell.productImageView.layer.borderColor = UIColor.clear.cgColor
        }.disposed(by: disposebag)
    }
    
    
    
    
    private func ConfigureSizeCollectionView() {
        SizeCollectionView.register(UINib(nibName: SizeNibfileName, bundle: nil), forCellWithReuseIdentifier: SizeNibfileName)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 10, right: 0)
        
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.itemSize = CGSize(width: SizeCollectionView.frame.size.width / 3, height: SizeCollectionView.frame.size.height - 5)
        
        SizeCollectionView.collectionViewLayout = flowLayout
    }
    
    private func SubscribeToSizeCollection() {
        sizesBehaviour.asObservable().bind(to: SizeCollectionView.rx.items(cellIdentifier: SizeNibfileName, cellType: sizeCell.self)) {row , branch , cell in
            cell.ConfigureSizeCell(sizeNumber: branch)
        }.disposed(by: disposebag)
    }
    
    
    private func ConfigureColorCollectionView() {
        ColorCollectionView.register(UINib(nibName: SizeNibfileName, bundle: nil), forCellWithReuseIdentifier: SizeNibfileName)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.itemSize = CGSize(width: ColorCollectionView.frame.size.height, height: SizeCollectionView.frame.size.height)
        
        ColorCollectionView.collectionViewLayout = flowLayout
    }
    
    private func SubscribeToColorCollection() {
        colorsBehaviour.asObservable().bind(to: ColorCollectionView.rx.items(cellIdentifier: SizeNibfileName, cellType: sizeCell.self)) {row , branch , cell in
            cell.ConfigureColorCell(colorCode: branch)
        }.disposed(by: disposebag)
    }
    
    private func FlowLayout(width: CGFloat, hight: CGFloat) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        
        flowLayout.itemSize = CGSize(width: width, height: hight)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        return flowLayout
    }
}
