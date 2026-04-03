//
//  RealtimeSocketLogView.swift
//  artive
//
//  로그인 후 WebSocket 수신 로그 확인용 화면
//

import SwiftUI

struct RealtimeSocketLogView: View {

    @EnvironmentObject private var navManager: NavigationManager
    @EnvironmentObject private var useRealtimeLog: UseRealtimeSocketLog

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    ForEach(useRealtimeLog.lines.reversed()) { entry in
                        Text(entry.text)
                            .font(.system(.footnote, design: .monospaced))
                            .textSelection(.enabled)
                    }
                } header: {
                    Text("수신 로그 (최신 위)")
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("실시간 소켓")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("메인") {
                    navManager.currentScreen = .main
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("로그아웃") {
                    DependencyContainer.shared.resolve(type: RealtimeSocketServiceProtocol.self).disconnect()
                    DependencyContainer.shared.resolve(type: ServiceStorageProtocol.self).clearAll()
                    navManager.currentScreen = .login
                }
            }
        }
        .onAppear {
            useRealtimeLog.appendLog("화면 진입 (서버에서 오는 메시지가 아래에 쌓입니다)")
        }
    }
}
