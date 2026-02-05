//
//  ContentView.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        Group {
            //로그인 여부
            if authManager.isAuthenticated {
                ArtworkView()
            } else {
                NavigationStack {
                    LoginView()
                }
            }
        }
        .animation(.default, value: authManager.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
