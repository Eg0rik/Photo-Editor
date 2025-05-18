//
//  UINavigationController.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
