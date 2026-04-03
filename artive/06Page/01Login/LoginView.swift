//
//  LoginView.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//

import SwiftUI

struct LoginView: View {

    @Environment(\.presentationMode) var presentationMode
    // 뷰모델 연결
    @StateObject var useAuth = UseAuth()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        // AppLauncherView와 같이 BaseView로 감싸야 useAuth.destination 변경 시
        // BaseView.onChange → navManager.currentScreen 전환이 동작함. (realtime/루트 로그인은 dismiss로는 메인으로 안 감)
        BaseView(baseUse: useAuth) {
            VStack(spacing: 20) {
                Text("로그인 테스트")
                    .font(.largeTitle)
                    .bold()
                
                VStack {
                    TextField("이메일", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    
                    SecureField("비밀번호", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                
                if useAuth.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        useAuth.login(email: email, pw: password)
                    }) {
                        Text("로그인하기")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Text(useAuth.isLoggedIn ? "로그인 상태: ✅ 성공" : "로그인 상태: ❌ 로그아웃")
                    .padding()
                
                if let error = useAuth.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
        }
        // sheet 등으로 밀어 올린 경우 pop — RootView 루트(.login)에서는 보통 no-op, 전환은 BaseView가 처리
        .onChange(of: useAuth.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
