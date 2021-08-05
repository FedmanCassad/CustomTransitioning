//
//  ViewController.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

class ViewController: UIViewController {

	private var anotherVCTransitioningDelegate: CustomModalTransitionDelegate!
	lazy var button: UIButton = {
let button = UIButton(frame: CGRect(x: 0,
									y: 0,
									width: 100,
									height: 30))
		button.setTitle("Show VC", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.addTarget(self, action: #selector(goToAnotherVC), for: .touchUpInside)
		button.center = view.center
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(button)
	}


	@objc
	func goToAnotherVC() {
		let controller = AnotherViewController()
		anotherVCTransitioningDelegate = CustomModalTransitionDelegate(from: self, to: controller)
		controller.modalPresentationStyle = .custom
		controller.transitioningDelegate = anotherVCTransitioningDelegate
		present(controller, animated: true, completion: nil)
	}

}

