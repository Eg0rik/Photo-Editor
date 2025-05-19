//
//  MainScreen.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import SwiftUI
import FirebaseAuth

struct MainScreen: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = MainScreenViewModel()
    
    var body: some View {
        VStack {
            
        }
    }
}

private extension MainScreen {
    func signOut() {
        viewModel.signOut {
            appCoordinator.setRoot(.auth)
        } errorMessage: { message in
            appCoordinator.showAlert(title: "Sign out error", message: message)
        }
    }
}
