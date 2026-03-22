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
                    // 로그인 API 요청
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
        .onChange(of: useAuth.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}
