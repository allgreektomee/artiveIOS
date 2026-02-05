//
//  LoginView.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//

import SwiftUI

struct LoginView: View {

    // 뷰모델 연결
    @StateObject var viewModel = UserViewModel()
    
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
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button(action: {
                    // 로그인 API 요청
                    viewModel.login(email: email, pw: password)
                }) {
                    Text("로그인하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Text(viewModel.isLoggedIn ? "로그인 상태: ✅ 성공" : "로그인 상태: ❌ 로그아웃")
                .padding()
            
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}
