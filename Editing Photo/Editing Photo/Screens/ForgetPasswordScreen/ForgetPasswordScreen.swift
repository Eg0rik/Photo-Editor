//
//  ForgetPasswordScreen.swift
//  Editing Photo
//
//  Created by mac on 18.05.25.
//

import SwiftUI

struct ForgetPasswordScreen: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = ForgetPasswordScreenViewModel()
    @State var showAlert = false
    @State var isLoading = false
    
    var body: some View {
        content()
    }
    
    func content() -> some View {
        ZStack {
            Color.background.ignoresSafeArea()
                VStack(spacing: 25) {
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            appCoordinator.dismissSheet()
                        } label: {
                            Image(systemName: "multiply.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.text)
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    ValidatedTextField(name: "Email", text: $viewModel.email, errorMessage: $viewModel.emailErrorMessage)
                    
                    Button("Send code to email", action: sendPasswordReset)
                        .buttonStyle(
                            BigButtonStyle(
                                background: viewModel.isButtonEnabled ? AnyShapeStyle(LinearGradient.mainGradient) : AnyShapeStyle(Color.gray)
                            )
                        )
                        .padding(.top, 6)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .navigationTitle("Reset password")
                .alert("Check you email", isPresented: $showAlert) {
                    Button("Ok", role: .cancel) {
                        appCoordinator.dismissSheet()
                    }
                }
            
            if isLoading {
                CustomProgressView()
            }
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
    }
}

private extension ForgetPasswordScreen {
    func sendPasswordReset() {
        isLoading = true
        
        viewModel.sendPasswordReset {
            isLoading = false
            showAlert = true
        } errorMessage: { message in
            isLoading = false
            appCoordinator.showAlert(title: "Error", message: message)
        }
    }
}

#Preview {
    ForgetPasswordScreen()
}
