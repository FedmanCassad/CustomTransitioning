//
//  CustomModalPresentationController.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

enum ModalScaleState {
	case presenting
	case interaction
}

final class CustomModalPresentationController: UIPresentationController {
	private let presentedYOffset: CGFloat = 35
	private var direction: CGFloat = 0
	private var state: ModalScaleState = .interaction
	private lazy var fadingView: UIView! = {
		guard let container = containerView else { return nil }
		let view = UIView(frame: container.bounds)
		view.backgroundColor = .black.withAlphaComponent(0.75)
		let gr = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
		view.addGestureRecognizer(gr)
		return view
	}()

	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		let gr = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
		presentedViewController.view.addGestureRecognizer(gr)
	}
	@objc
	func didTap(sender: UITapGestureRecognizer) {
		presentedViewController.dismiss(animated: true, completion: nil)
	}

	@objc
	func didPan(sender: UIPanGestureRecognizer) {
		guard let view = sender.view, let superView = view.superview,
			  let presented = presentedView, let container = containerView else { return }

		let location = sender.translation(in: superView)

		switch sender.state {
			case .began:
				presented.frame.size.height = container.frame.height
			case .changed:
				let velocity = sender.velocity(in: superView)

				switch state {
					case .interaction:
						presented.frame.origin.y = location.y + presentedYOffset
					case .presenting:
						presented.frame.origin.y = location.y
				}
				direction = velocity.y
			case .ended:
				let maxPresentedY = container.frame.height - presentedYOffset - 500
				switch presented.frame.origin.y {
					case 0...maxPresentedY:
						changeScale(to: .interaction)
					default:
						presentedViewController.dismiss(animated: true, completion: nil)
				}
			default:
				break
		}
	}

	func changeScale(to state: ModalScaleState) {
		guard let presented = presentedView else { return }

		UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5,
					   initialSpringVelocity: 0.5,
					   options: .curveEaseInOut, animations: { [weak self] in
			guard let `self` = self else { return }

			presented.frame = self.frameOfPresentedViewInContainerView

		}, completion: { (isFinished) in
			self.state = state
		})
	}

	override var frameOfPresentedViewInContainerView: CGRect {
		guard let container = containerView else { return .zero }

		return CGRect(x: 0, y: self.presentedYOffset, width: container.bounds.width, height: container.bounds.height - self.presentedYOffset)
	}

	override func presentationTransitionWillBegin() {
		guard let container = containerView,
			  let coordinator = presentingViewController.transitionCoordinator else { return }

		fadingView.alpha = 0
		container.addSubview(fadingView)
		fadingView.addSubview(presentedViewController.view)

		coordinator.animate(alongsideTransition: { [weak self] context in
			guard let `self` = self else { return }

			self.fadingView.alpha = 1
		}, completion: nil)
	}

	override func dismissalTransitionWillBegin() {
		guard let coordinator = presentingViewController.transitionCoordinator else { return }

		coordinator.animate(alongsideTransition: { [weak self] (context) -> Void in
			guard let `self` = self else { return }

			self.fadingView.alpha = 0
		}, completion: nil)
	}

	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			fadingView.removeFromSuperview()
		}
	}
}

