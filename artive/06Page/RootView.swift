//
//  RootView.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/11/26.
//
import SwiftUI

struct RootView: View {
    @StateObject private var navManager = NavigationManager()
    @StateObject private var useRealtimeSocketLog: UseRealtimeSocketLog = DependencyContainer.shared.resolve(
        type: UseRealtimeSocketLog.self
    )
    /// 세션 축출 등: 취소 없이 확인만 가능한 안내
    @State private var showForcedLogoutAlert = false

    var body: some View {
        NavigationStack(path: $navManager.path) {
            // ✅ currentScreen 상태 변경 감지 및 화면 교체
            Group {
                switch navManager.currentScreen {
                case .launch:
                    AppLauncherView()
                case .login:
                    
                    LoginView()
                case .main:
                    MainVIew()
                case .realtimeSocket:
                    RealtimeSocketLogView()
                case .webView(url: let url):
                    Text("webView")
                        .font(.largeTitle)
                }
            }
            // ✅ 네비게이션 스택(Push) 이동 경로 처리
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .launch:
                    AppLauncherView()
                case .login:
                    // TODO: 실제 로그인 뷰로 교체
                    Text("로그인 화면")
                        .font(.largeTitle)
                case .main:
                    MainVIew()
                case .realtimeSocket:
                    RealtimeSocketLogView()
                case .webView(url: let url):
                    Text("webView")
                        .font(.largeTitle)
                }
            }
        }
        .environmentObject(navManager)
        .environmentObject(useRealtimeSocketLog)
        .alert("안내", isPresented: $showForcedLogoutAlert) {
            Button("확인") {
                navManager.popToRoot()
                navManager.currentScreen = .login
                showForcedLogoutAlert = false
            }
        } message: {
            Text("로그아웃되었습니다.")
        }
        .onChange(of: navManager.sessionSupersededEpoch) { _, newEpoch in
            guard newEpoch > 0 else { return }
            let c = DependencyContainer.shared
            c.resolve(type: RealtimeSocketServiceProtocol.self).disconnect()
            c.resolve(type: ServiceStorageProtocol.self).clearAll()
            showForcedLogoutAlert = true
            DLog("다른 세션으로 로그인되어 연결이 해제되었습니다.", type: .warning)
        }
        .onAppear {
            let c = DependencyContainer.shared
            let nav = navManager
            c.resolve(type: RealtimeSocketServiceProtocol.self).onSessionSuperseded = {
                nav.signalSessionSuperseded()
            }
        }
    }
}
