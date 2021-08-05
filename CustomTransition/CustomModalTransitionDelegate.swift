//
//  CustomModalTransitionDelegate.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

final class CustomModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
	var interactiveDismiss = true

	init(from currentlyPresented: UIViewController, to presenting: UIViewController) {
		super.init()
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		nil
	}

	func presentationController(forPresented presented: UIViewController,
								presenting: UIViewController?,
								source: UIViewController) -> UIPresentationController? {
	return CustomModalPresentationController(presentedViewController: presented, presenting: presenting)
	}
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
	-> UIViewControllerInteractiveTransitioning? {
		nil
	}
	
}
