//
//  BaseView.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/11/26.
//
import SwiftUI


struct BaseView<Content: View, BU: BaseUse>: View {
    
    @ObservedObject var baseUse: BU
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navManager: NavigationManager
    
    let content: Content

    init(baseUse: BU, @ViewBuilder content: () -> Content) {
        self.baseUse = baseUse
        self.content = content()
    }

    var body: some View {
        ZStack {
            content
                .disabled(baseUse.isLoading)
            
            if baseUse.isLoading {
                // 로딩 인디케이터 (색상은 앱 메인 컬러로 맞추시면 좋습니다)
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1)) // 가볍게 배경 딤 처리
            }
        }
        //
        .onChange(of: baseUse.destination) { newValue in
            if let route = newValue {
             
                navManager.currentScreen = route
                
                // 이동 후 상태 초기화 (중요: 메인 스레드에서 처리)
                DispatchQueue.main.async {
                    baseUse.destination = nil
                }
            }
        }

        // ✅ 공통 알럿 처리 ㅇ
        .alert(
            "알림",
            isPresented: Binding<Bool>(
                get: { baseUse.alertMessage != nil },
                set: { if !$0 { baseUse.alertMessage = nil } }
            )
        ) {
            Button("확인") {
                if baseUse.shouldDismiss {
                    dismiss()
                    baseUse.shouldDismiss = false
                }
            }
        } message: {
            Text(baseUse.alertMessage ?? "")
        }
    }
}
