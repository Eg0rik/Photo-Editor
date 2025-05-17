//
//  RootScreen.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import SwiftUI

struct RootView: View {
    
    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        NavigationStack{
            AuthScreen()
        }
    }
}

private extension RootView {
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .background
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
