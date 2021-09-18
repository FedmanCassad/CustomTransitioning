//
//  ModalViewController.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

protocol HasViewToSwipeForDismissProtocol {
    var viewToSwipe: UIView { get }
}

final class AnotherViewController: UIViewController {
	lazy var label: UILabel = {
		let label = UILabel()
		label.text = "Hello there, Pavel!"
		label.sizeToFit()
        label.center.x = view.center.x
        label.frame.origin.y = 50
		label.textColor = .magenta
        label.isUserInteractionEnabled = true
		return label
	}()

	override func viewDidLoad() {
		view.backgroundColor = .green
		view.addSubview(label)
		view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
	}
}

extension AnotherViewController: HasViewToSwipeForDismissProtocol {
    var viewToSwipe: UIView { label }
}
