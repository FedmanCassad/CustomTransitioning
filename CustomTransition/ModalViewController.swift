//
//  ModalViewController.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

final class AnotherViewController: UIViewController {
	lazy var label: UILabel = {
		let label = UILabel()
		label.text = "Hello there, Pavel!"
		label.sizeToFit()
		label.center = view.center
		label.textColor = .magenta

		return label
	}()

	override func viewDidLoad() {
		view.backgroundColor = .green
		view.addSubview(label)
	}
}
