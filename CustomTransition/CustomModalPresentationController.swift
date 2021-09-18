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
        guard let containerView = containerView else { return .zero }
        return CGRect(
            x: 0,
            y: presentedViewYOffset,
            width: containerView.bounds.width,
            height: containerView.bounds.height - presentedViewYOffset
        )
    }
    
    // MARK: - Private Properties
    
    private lazy var presentedViewYOffset: CGFloat = 135
    private var swipeVelocity: CGFloat = 0
    
    private lazy var fadingView: UIView = {
        guard let containerView = containerView else { return UIView() }
        let view = UIView(frame: containerView.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.75)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func presentationTransitionWillBegin() {
        print(#function, #line)
        guard
            let container = containerView,
            let coordinator = presentingViewController.transitionCoordinator
        else { return }
        
        addGestureRecognizers()
        
        container.addSubview(fadingView)
        container.addSubview(presentedViewController.view)
        
        coordinator.animate(
            alongsideTransition: { [self] _ in
            fadingView.alpha = 1
        },
            completion: nil
        )
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { [self] _ in
            fadingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            fadingView.removeFromSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapPastPresentedScreen() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didPan(sender: UIPanGestureRecognizer) {
        guard let presentedView = presentedView,
              let containerView = containerView else { return }
        
        let translation = sender.translation(in: containerView)
        
        switch sender.state {
        case .changed:
            let velocity = sender.velocity(in: containerView)
            self.swipeVelocity = velocity.y
            
            let newOriginYPosition = translation.y + presentedViewYOffset
            
            // Устанавливаем границу, выше которой нельзя растягивать наш презентуемый экран
            guard newOriginYPosition >= frameOfPresentedViewInContainerView.minY else { return }
            presentedView.frame.origin.y = presentedViewYOffset + translation.y
            
        case .ended:
            let presentedViewYPosition = presentedView.frame.origin.y
            let yThresholdForDismiss = containerView.frame.height * 0.5
            
            // Если скорость смахивания достаточно высокая - значит пользователь хочет смахнуть окно. Если он достаточно далеко вниз отвел окно и отпустил, то скорее всего он тоже хочет смахнуть окно. В ином случае нужно вернуть нашу вьюху на место.
            if swipeVelocity > 650 || presentedViewYPosition > yThresholdForDismiss {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                reinstateInitialPosition()
            }
            
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    
    private func addGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPastPresentedScreen))
        fadingView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func reinstateInitialPosition() {
        guard let presentedView = presentedView else { return }
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.9,
            options: .curveEaseInOut
        ) { [self] in
            presentedView.frame = frameOfPresentedViewInContainerView
        }
    }
    
}

