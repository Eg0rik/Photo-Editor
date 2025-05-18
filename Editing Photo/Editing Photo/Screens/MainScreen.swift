//
//  MainScreen.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import SwiftUI

struct MainScreen: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = MainScreenViewModel()
    
    var body: some View {
        Button("Sign Out") {
            viewModel.signOut()
        }
    }
}
