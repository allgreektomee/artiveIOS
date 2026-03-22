
//
//  LogPage.swift
//  artive
//
//  Created by Park Jae Young on 3/20/26.
//

import SwiftUI
struct LogView: View {
    let data: LogResponse
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                // --- 상단: 기존 메인 레이아웃 섹션 ---
                // 높이를 고정(예: 650)하여 첫 화면에서는 기존 디자인처럼 보이게 합니다.
                ZStack(alignment: .leading) {
                    Color.black // 로그는 블랙 무드 유지
                    
                    // 배경 타이포
                    Text("LOG")
                        .font(.custom("LibreBaskerville-Bold", size: 120))
                        .foregroundColor(Color.white.opacity(0.08))
                        .offset(x: 50, y: 150)
                    
                    // 기존 템플릿 호출 (padding 등 조정)
                    Group {
                        switch data.layoutType {
                        case "A": templateA()
                        case "B": templateB()
                        case "C": templateC()
                        default:  templateA()
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 100)
                }
                .frame(minHeight: UIScreen.main.bounds.height * 0.8) // 첫 화면 꽉 차게
                
                // --- 하단: 추가된 상세 컨텐츠 섹션 ---
                VStack(alignment: .leading, spacing: 40) {
                    // 구분선
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 1)
                    
                    Text("THE EDITORIAL")
                        .font(.system(size: 10, weight: .bold))
                        .kerning(4)
                        .foregroundColor(.blue.opacity(0.8))

                    Text(data.content)
                        .font(.system(size: 17))
                        .lineSpacing(12)
                        .foregroundColor(.white.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // 마무리 푸터 느낌
                    Text(data.date)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.top, 20)
                }
                .padding(40)
                .background(Color.black)
                
                Spacer(minLength: 100)
            }
        }
        .background(Color.black.ignoresSafeArea())
    }

    // --- 기존 템플릿 함수들 (동일하게 유지하되 크기 최적화) ---
    func templateA() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            logImage(url: data.mainImage, width: UIScreen.main.bounds.width - 60, height: 380)
            VStack(alignment: .leading, spacing: 12) {
                Text(data.tag).tagStyle().foregroundColor(.blue.opacity(0.8))
                Text(data.title).titleStyle().foregroundColor(.white)
            }
        }
    }

    func templateB() -> some View {
        VStack(alignment: .trailing, spacing: 40) {
            VStack(alignment: .trailing, spacing: 12) {
                Text(data.tag).tagStyle()
                Text(data.title).titleStyle().multilineTextAlignment(.trailing).foregroundColor(.white)
            }
            logImage(url: data.mainImage, width: UIScreen.main.bounds.width * 0.75, height: 320)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    func templateC() -> some View {
        VStack(alignment: .leading, spacing: 70) {
            ZStack(alignment: .bottomTrailing) {
                logImage(url: data.mainImage, width: UIScreen.main.bounds.width * 0.7, height: 350)
                if let subUrl = data.subImage {
                    logImage(url: subUrl, width: 160, height: 200)
                        .border(Color.black, width: 3).shadow(radius: 15).offset(x: 20, y: 50)
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(data.title).titleStyle().foregroundColor(.white)
                Text(data.tag).tagStyle().foregroundColor(.blue.opacity(0.8))
            }
        }
    }

    func logImage(url: String, width: CGFloat, height: CGFloat) -> some View {
        AsyncImage(url: URL(string: url)) { img in
            img.resizable().aspectRatio(contentMode: .fill)
        } placeholder: { Color.white.opacity(0.1) }
        .frame(width: width, height: height).clipped()
    }
}
