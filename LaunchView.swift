//
//  LaunchView.swift
//  artive
//
//  Created by Park Jae Young on 2/9/26.
//

import SwiftUI

struct LaunchView: View {
    @Binding var isShowingLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Artive") // TODO: 로고 이미지로 교체
                .font(.largeTitle.bold())
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isShowingLaunchView = false
            }
        }
    }
}