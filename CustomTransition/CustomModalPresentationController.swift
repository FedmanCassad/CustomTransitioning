//
//  CustomModalPresentationController.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

final class CustomModalPresentationController: UIPresentationController {
    
    // MARK: - Public Properties
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        return CGRect(
            x: 0,
            y: presentedYOffset,
            width: container.bounds.width,
            height: container.bounds.height - presentedYOffset
        )
    }
    
    // MARK: - Private Properties
    
    private var isInteractionModalScaleState = true
    private lazy var presentedYOffset: CGFloat = isInteractionModalScaleState ? 35 : 0
    private var velocity: CGFloat = 0
    
    private lazy var fadingView: UIView = {
        guard let container = containerView else { return UIView() }
        let view = UIView(frame: container.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.75)
        let gr = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(gr)
        return view
    }()
    
    // MARK: - Initializers
    
    override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )
        let gr = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        presentedViewController.view.addGestureRecognizer(gr)
    }
    
    // MARK: - Life Cycle
    
    override func presentationTransitionWillBegin() {
        guard
            let container = containerView,
            let coordinator = presentingViewController.transitionCoordinator
        else { return }
        
        fadingView.alpha = 0
        container.addSubview(fadingView)
        fadingView.addSubview(presentedViewController.view)
        
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.fadingView.alpha = 1
        },
            completion: nil
        )
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator
        else { return }
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.fadingView.alpha = 0
        },
            completion: nil
        )
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            fadingView.removeFromSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func didPan(sender: UIPanGestureRecognizer) {
        guard
            let view = sender.view,
            let superView = view.superview,
            let presented = presentedView,
            let container = containerView
        else { return }
        
        let location = sender.translation(in: superView)
        
        switch sender.state {
        case .began:
            presented.frame.size.height = container.frame.height
            
        case .changed:
            let velocity = sender.velocity(in: superView)
            presented.frame.origin.y = location.y + presentedYOffset
            self.velocity = velocity.y
            
        case .ended:
            let maxPresentedY = container.frame.height - presentedYOffset - 500
            switch presented.frame.origin.y {
            case 0...maxPresentedY:
                changeScale()
            default:
                presentedViewController.dismiss(animated: true, completion: nil)
            }
            
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    
    private func changeScale() {
        guard let presented = presentedView else { return }
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.9,
            options: .curveEaseInOut
        ) { [weak self] in
            guard let self = self else { return }
            presented.frame = self.frameOfPresentedViewInContainerView
        }
    }
    
}

