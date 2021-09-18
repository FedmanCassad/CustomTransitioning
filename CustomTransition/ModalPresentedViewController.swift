//
//  ModalPresentedViewController.swift
//  CustomTransition
//
//  Created by Vladimir Banushkin on 06.08.2021.
//

import UIKit

protocol CustomModalPresentedViewController: UIViewController {
    var presentedViewHeight: CGFloat { get }
    var viewToSwipeForDismissing: UIView { get }
}

final class ModalPresentedViewController: UIViewController {
    
    // MARK: - Public Properties
    
    lazy var label: UILabel = {
        $0.text = "Hello there, Pavel!"
        $0.sizeToFit()
        $0.center.x = view.center.x
        $0.frame.origin.y = 50
        $0.textColor = .magenta
        $0.isUserInteractionEnabled = true
        return $0
    }(UILabel())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        view.addSubview(label)
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}

// MARK: - CustomModalPresentedViewController

extension ModalPresentedViewController: CustomModalPresentedViewController {
    var presentedViewHeight: CGFloat { 500 }
    var viewToSwipeForDismissing: UIView { label }
}
