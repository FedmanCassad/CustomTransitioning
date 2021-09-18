//
//  ViewController.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var anotherVCTransitioningDelegate: CustomModalTransitionDelegate!
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Show VC", for: .normal)
        button.sizeToFit()
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(goToAnotherVC), for: .touchUpInside)
        button.center = view.center
        return button
    }()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(button)
		overrideUserInterfaceStyle = .light
	}


	@objc func goToAnotherVC() {
        let vc = ModalPresentedViewController()
        customModalTransitionDelegate = CustomModalTransitionDelegate(from: self, to: vc)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customModalTransitionDelegate
        present(vc, animated: true, completion: nil)
	}

}

