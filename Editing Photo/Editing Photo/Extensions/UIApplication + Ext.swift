//
//  UIApplication + Ext.swift
//  Editing Photo
//
//  Created by mac on 20.05.25.
//

import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
