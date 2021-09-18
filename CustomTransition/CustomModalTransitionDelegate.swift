//
//  CustomModalTransitionDelegate.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

final class CustomModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - Private Properties
    
    private let presentingViewController: UIViewController
    private let presentedViewController: CustomModalPresentedViewController
    
    // MARK: - Initializers
    
    init(
        from presentingViewController: UIViewController,
        to presentedViewController: CustomModalPresentedViewController
    ) {
        self.presentingViewController = presentingViewController
        self.presentedViewController = presentedViewController
    }
    
    // MARK: - Public Methods

	func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
		nil
	}

	func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let customModalPresentationController = CustomModalPresentationController(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )
        return customModalPresentationController
    }
    
	func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
		nil
	}
	
}
