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
        Button("Sign Out") {
            viewModel.signOut()
        }
        
        Button("Confirm email") {
            viewModel.sendEmailVerification {
                appCoordinator.showAlert(title: "Check you email", message: "We sent confirmation link")
            } errorMessage: { message in
                appCoordinator.showAlert(title: "Confirm email error", message: message)
            }
        }
    }
}
