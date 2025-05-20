//
//  CustomProgressView.swift
//  Editing Photo
//
//  Created by mac on 20.05.25.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        VStack {
            ProgressView("Loading")
        }
        .frame(width: 120, height: 120)
        .background(.ultraThinMaterial)
    }
}
