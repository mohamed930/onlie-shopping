//
//  finishViewController.swift
//  online shopping
//
//  Created by Mohamed Ali on 30/09/2022.
//

import UIKit
import Lottie
import RxSwift

class finishViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var homeButton: UIButton!
    
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureAnimation()
        SubscribeTohomeButtonAction()
    }
    
    func ConfigureAnimation() {
        animationView.animation = Animation.named("complete")
//        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.play()
    }
    
    func SubscribeTohomeButtonAction() {
        homeButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            let story = UIStoryboard(name: "products", bundle: nil)
            let nextVC = story.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            nextVC.modalPresentationStyle = .fullScreen
            
            self.present(nextVC, animated: true)
        }).disposed(by: disposebag)
    }
    
}
