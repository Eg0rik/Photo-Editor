//
//  UIApplication.swift
//  Editing Photo
//
//  Created by mac on 18.05.25.
//

import UIKit

extension UIViewController {
    static var rootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController
    }
}
