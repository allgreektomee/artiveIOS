//
//  PageStatusIndicator.swift
//  artive
//
//  Created by Park Jae Young on 3/20/26.
//

import SwiftUI

struct PageStatusIndicator: View {
    let currentIndex: Int
    let totalCount: Int
    
    @State private var moveOffset: CGFloat = 0

    var body: some View {
        VStack {
            // 1. 위쪽을Spacer로 다 채워서 아래로 밀어냅니다.
            Spacer()
            
            if totalCount > 1 {
                Group {
                    if currentIndex == 0 {
                        Image(systemName: "triangle.fill")
                            .rotationEffect(.degrees(180))
                    } else if currentIndex == totalCount - 1 {
                        Image(systemName: "triangle.fill")
                    } else {
                        Image(systemName: "circle.fill")
                    }
                }
                .font(.system(size: 10))
                .foregroundColor(.black)
                .offset(y: moveOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        moveOffset = 8
                    }
                }
            }
        }
        .frame(width: 40)
        // 2. 바닥에서 얼마나 띄울지 결정 (하단 캡슐 인디케이터 높이와 맞추면 예쁩니다)
        .padding(.bottom, 45)
    }
}
