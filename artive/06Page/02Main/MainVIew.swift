//
//  MainVIew.swift
//  artive
//
//  Created by Park Jae Young on 3/20/26.
//
import SwiftUI

struct MainVIew: View {
    @StateObject var useAppLauncher = UseAppLauncher()
    @State private var currentPage = 0
// ▽ 추가: 세로 페이지 상태를 추적할 변수
    @State private var verticalPageIndex = 0
    @State private var verticalPageTotal = 0

    
    var body: some View {
        BaseView(baseUse: useAppLauncher) {
            ZStack {
                // 1. 배경색 (아이보리 톤)
                Color(red: 0.97, green: 0.97, blue: 0.96).ignoresSafeArea()
                
                // 2. 가로 매거진 본문
                TabView(selection: $currentPage) {
                    // 1. 인사이트 (도입)
                    InsightPage()
                        .tag(0)
                   
                    // 2. 전시 메인 (대표 화보)
                    ExhibitionPage(currentIndex: $verticalPageIndex, totalCount: $verticalPageTotal, mainTab: currentPage)
                        .tag(1)

                   

                    // 4. 작품 아카이브 (랜덤 그리드)
                    ArtworkPage(currentIndex: $verticalPageIndex, totalCount: $verticalPageTotal)
                        .tag(2)

                    // 5. 비하인드 로그 (마무리)
                    ForEach(0..<dummyLogs.count, id: \.self) { index in
                        LogView(data: dummyLogs[index])
                            .tag(3 + index) // 4번부터 로그 시작
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea()
                .onChange(of: currentPage) { oldValue, newValue in
                    // 💡 핵심: 페이지가 '완전히' 바뀌었을 때만 실행
                    if oldValue != newValue {
                        verticalPageIndex = 0 // 세로 번호 초기화
                        
                        // 💡 [도착지 검사] 인디케이터가 없어야 할 페이지(1, 2, 4번 등)면 강제로 0 처리
                        // Exhibition(0)과 Artist(3)만 인디케이터를 살려둡니다.
                        if newValue == 1 || newValue == 2 || newValue == 4 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                verticalPageTotal = 0
                            }
                        }
                    }
                }
                
                // 3. 고정 헤더
                VStack {
                    HStack {
                        Text("ARTIVE")
                            .font(.custom("LibreBaskerville-Bold", size: 14))
                            .kerning(6)
                        Spacer()
                        Text("VOL. 01")
                            .font(.custom("LibreBaskerville-Italic", size: 10))
                            .opacity(0.4)
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .foregroundColor(currentPage == 2 ? .white : .black)
                    .animation(.easeInOut, value: currentPage)
                    Spacer()
                }
                
                // 1. 계산된 프로퍼티: 전체 페이지 수 (전시1 + 인사이트1 + 로그N + 아티스트1 + 아트워크1)
                var totalMainPages: Int {
                    3 + dummyLogs.count + 1 // 전시, 인사이트, 아티스트, 아트워크(4장) + 로그 개수
                }

               

                // --- 인디케이터 UI 부분 ---
                VStack(alignment: .leading) {
                    Spacer()
                    HStack(spacing: 8) {
                        // 고정 5가 아니라 전체 페이지 수만큼 반복
                        ForEach(0..<totalMainPages, id: \.self) { i in
                            Capsule()
                                .fill(
                                    currentPage == i
                                    ? (isLogPage(i) ? .white : .black) // 현재 페이지가 로그면 화이트, 아니면 블랙
                                    : (isLogPage(currentPage) ? Color.white.opacity(0.2) : Color.gray.opacity(0.2)) // 비활성 상태도 배경색에 맞게 대응
                                )
                                .frame(width: currentPage == i ? 30 : 5, height: 5)
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Spacer()
                    // 우리가 만든 부품!
                    PageStatusIndicator(
                        currentIndex: verticalPageIndex,
                        totalCount: verticalPageTotal
                    )
                    .padding(.trailing, 20)
                }
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            useAppLauncher.appInfo()
        }
    }
}
// 2. 헬퍼 함수: 현재 인덱스가 로그 페이지 범위인지 확인
func isLogPage(_ index: Int) -> Bool {
    let logStartIndex = 2
    let logEndIndex = logStartIndex + dummyLogs.count
    return index >= logStartIndex && index < logEndIndex
}


// MARK: - PAGE 01: EXHIBITION (가로 지면 중 첫 번째)


// MARK: - PAGE 02: INSIGHT (인터랙티브 리스트 & 영역 보호)
struct InsightPage: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 50) {
                
                // 1. 헤더 여백 (ARTIVE 로고 공간)
                Color.clear.frame(height: 120)
                
                // 2. 이번 호의 테마 요약 (Editorial Note)
                VStack(alignment: .leading, spacing: 20) {
                    Text("PROLOGUE")
                        .font(.system(size: 11, weight: .bold))
                        .kerning(3)
                        .foregroundColor(.blue)
                    
                    Text("침묵의 기술:\n공간이 말을 걸 때")
                        .font(.custom("LibreBaskerville-Bold", size: 34))
                        .lineSpacing(8)
                    
                    Text("이번 VOL.01에서는 '침묵'이라는 주제를 통해 작가들이 공간과 어떻게 대화하는지 탐구합니다. 채우는 것보다 비우는 것이 더 어려운 시대, 우리는 그 여백 속에서 진정한 울림을 찾고자 합니다.")
                        .font(.system(size: 15))
                        .lineSpacing(6)
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.top, 10)
                }
                .padding(.horizontal, 30)
                
                // 3. 💡 감각적인 목차 (Navigation Index)
                // 독자가 다음에 무엇이 나올지 기대하게 만듭니다.
                VStack(alignment: .leading, spacing: 30) {
                    Text("CONTENTS")
                        .font(.system(size: 11, weight: .bold))
                        .kerning(3)
                        .padding(.bottom, 10)
                    
                    IndexRow(num: "01", title: "MAIN EXHIBITION", desc: "빛과 그림자의 변주곡")
                    IndexRow(num: "02", title: "CONTRIBUTORS", desc: "참여 작가 3인의 철학")
                    IndexRow(num: "03", title: "ARCHIVE", desc: "미공개 작품 컬렉션")
                    IndexRow(num: "04", title: "BEHIND LOGS", desc: "전시 준비 120일의 기록")
                }
                .padding(.horizontal, 30)
                
                // 4. 하단 이미지 포인트 (작게)
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?q=80&w=400")) { i in
                    i.resizable().aspectRatio(contentMode: .fill)
                } placeholder: { Color.gray.opacity(0.1) }
                .frame(height: 180)
                .clipped()
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer(minLength: 150)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.96))
    }
}

// MARK: - 목차 행 부품
struct IndexRow: View {
    let num: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Text(num)
                .font(.custom("LibreBaskerville-Italic", size: 14))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .kerning(1)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.5))
            }
        }
        .padding(.bottom, 5)
    }
}

struct LogGalleryView: View {
    let logs: [LogResponse]
    
    var body: some View {
        TabView {
            ForEach(logs) { log in
                LogView(data: log)
                    // 만약 이 안에서도 세로 스크롤을 하려면 회전이 필요하지만,
                    // 현재는 가로 매거진의 한 페이지로 작동하게 설정합니다.
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}


struct ExhibitionArtistPage: View {
    @Binding var currentIndex: Int
    @Binding var totalCount: Int
    let mainTab: Int

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // --- SECTION 1: EXHIBITION MAIN ---
                VStack(alignment: .leading, spacing: 30) {
                    Color.clear.frame(height: 120) // 로고 여백
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("MAIN FEATURE").tagStyle()
                        
                        Text("Beyond the\nSilent Canvas")
                            .titleStyle()
                            .foregroundColor(.black)
                        
                        // ✍️ 추가된 서문
                        Text("침묵은 아무것도 없는 상태가 아니라, 모든 가능성이 응축된 순간입니다. 이번 전시는 캔버스의 빈 공간이 어떻게 우리에게 말을 거는지, 그 고요한 파동을 기록합니다.")
                            .font(.system(size: 15))
                            .lineSpacing(8)
                            .foregroundColor(.black.opacity(0.6))
                            .frame(width: 280, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(width: 40, height: 1)
                            .padding(.vertical, 10)
                    }
                    
                    // 메인 화보
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?q=80&w=800")) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.1)
                        }
                        .frame(height: 480)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .shadow(color: .black.opacity(0.06), radius: 25, x: 15, y: 25)
                        
                        Text("01")
                            .font(.system(size: 80, weight: .black))
                            .foregroundColor(.white.opacity(0.15))
                            .offset(x: -10, y: 30)
                    }
                }
                .padding(.horizontal, 30)

                // --- SECTION 2: THE DETAILS (심층 설명) ---
                VStack(alignment: .leading, spacing: 40) {
                    Text("THE DETAILS")
                        .font(.system(size: 10, weight: .bold))
                        .kerning(4)
                        .foregroundColor(.secondary)
                    
                    Text("빛은 사물의 형태를 드러내지만, 그림자는 사물의 깊이를 완성합니다. 우리는 너무 많은 소음 속에 살고 있지는 않나요?\n\n이번 'Beyond the Silent Canvas' 섹션에서는 의도된 비움이 주는 시각적 휴식과 그 안에서 피어나는 내면의 목소리에 집중합니다. 작가들이 배치한 여백의 미학을 통해 당신만의 해답을 찾아보세요.")
                        .font(.system(size: 17))
                        .lineSpacing(12)
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(40)
                .padding(.vertical, 60)

                // --- SECTION 3: BRIDGE ---
                VStack(spacing: 25) {
                    Rectangle().frame(width: 1, height: 80).opacity(0.2)
                    Text("DESIGNERS OF SILENCE")
                        .font(.system(size: 10, weight: .bold))
                        .kerning(5)
                        .foregroundColor(.secondary)
                    Text("이 고요를 설계한 3인의 관점")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.4))
                }
                .padding(.vertical, 60)

                // --- SECTION 4: ARTISTS (지그재그) ---
                VStack(spacing: 160) {
                    ArtistMagazineRow(
                        num: "01", name: "박재영 (J.P)",
                        role: "Creative Director",
                        img: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500",
                        isLeft: true,
                        quote: "공간의 본질은 무엇을 채우느냐가 아니라, 무엇을 남겨두느냐에 의해 결정됩니다."
                    )
                    
                    ArtistMagazineRow(
                        num: "02", name: "이안 (Ian)",
                        role: "Sound Artist",
                        img: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500",
                        isLeft: false,
                        quote: "완벽한 침묵은 존재하지 않습니다. 우리는 오직 고요를 통해 소리의 미세한 결을 느낄 뿐입니다."
                    )
                    
                    ArtistMagazineRow(
                        num: "03", name: "한수진 (S.J)",
                        role: "Installation Artist",
                        img: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500",
                        isLeft: true,
                        quote: "빛이 머무는 자리는 매 순간 변화합니다. 저는 그 찰나의 표정을 붙잡아 공간에 기록합니다."
                    )
                }
                .padding(.bottom, 150)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.96))
        .onAppear { totalCount = 0 }
    }
}

// 아티스트 행 부품 (워딩 포함)
struct ArtistMagazineRow: View {
    let num: String; let name: String; let role: String; let img: String; let isLeft: Bool; let quote: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if isLeft {
                imagePart.padding(.leading, 30)
                Spacer()
                textPart.padding(.trailing, 40)
            } else {
                textPart.padding(.leading, 40)
                Spacer()
                imagePart.padding(.trailing, 30)
            }
        }
    }
    
    var imagePart: some View {
        ZStack(alignment: isLeft ? .bottomTrailing : .bottomLeading) {
            AsyncImage(url: URL(string: img)) { i in
                i.resizable().aspectRatio(contentMode: .fill)
            } placeholder: { Color.gray.opacity(0.1) }
            .frame(width: 180, height: 260)
            .grayscale(1.0)
            .clipped()
            
            Text(num).font(.system(size: 80, weight: .black)).opacity(0.12).offset(y: 30)
        }
    }
    
    var textPart: some View {
        VStack(alignment: isLeft ? .leading : .trailing, spacing: 20) {
            VStack(alignment: isLeft ? .leading : .trailing, spacing: 6) {
                Text(role).font(.system(size: 9, weight: .bold)).kerning(2).foregroundColor(.blue)
                Text(name).font(.custom("LibreBaskerville-Bold", size: 22))
            }
            
            Text(quote)
                .font(.system(size: 14))
                .lineSpacing(7)
                .italic()
                .opacity(0.7)
                .multilineTextAlignment(isLeft ? .leading : .trailing)
                .frame(width: 150)
        }
        .padding(.top, 40)
    }
}



struct ArtworkPage: View {
    @Binding var currentIndex: Int
    @Binding var totalCount: Int
    
    // 💡 실제 작품들의 비율이 제각각이라고 가정 (가로형, 세로형 섞임)
    let artworks = (1...20).map { i in
        (title: "Collection #\(i)", artist: "KIM SEULGI", img: "https://picsum.photos/id/\(i+50)/600/800")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // 상단 여백
                Color.clear.frame(height: 120)
                
                // 타이틀
                VStack(alignment: .leading, spacing: 8) {
                    Text("ARCHIVE").font(.system(size: 11, weight: .bold)).kerning(3).foregroundColor(.blue)
                    Text("Works in Focus").font(.custom("LibreBaskerville-Italic", size: 32))
                }
                .padding(.horizontal, 30).padding(.bottom, 40)
                
                // 💡 2-1 랜덤 배치 (비율 보존형)
                VStack(spacing: 40) {
                    let rows = makeRandomRows(data: artworks)
                    ForEach(0..<rows.count, id: \.self) { rowIndex in
                        let row = rows[rowIndex]
                        
                        if row.count == 2 {
                            // 2열: 나란히 배치 (비율에 따라 높이가 다르게 보임)
                            HStack(alignment: .bottom, spacing: 15) {
                                ForEach(0..<row.count, id: \.self) { i in
                                    ArtworkFitCell(artwork: row[i] as! (title: String, artist: String, img: String), width: (UIScreen.main.bounds.width - 75) / 2)
                                }
                            }
                        } else {
                            // 1열: 크게 배치 (원본 구도 그대로)
                            ArtworkFitCell(artwork: row[0] as! (title: String, artist: String, img: String), width: UIScreen.main.bounds.width - 60)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer(minLength: 150)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.96))
        .onAppear { totalCount = 1 }
    }
    
    // 1개 또는 2개씩 묶는 랜덤 로직
    func makeRandomRows(data: [Any]) -> [[Any]] {
        var result: [[Any]] = []
        var temp = data
        while !temp.isEmpty {
            let count = Int.random(in: 1...2)
            result.append(Array(temp.prefix(count)))
            temp.removeFirst(min(count, temp.count))
        }
        return result
    }
}

// MARK: - 이미지 비율 보존 셀
struct ArtworkFitCell: View {
    let artwork: (title: String, artist: String, img: String)
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 💡 [핵심] 이미지 원본 비율을 살리는 구간
            AsyncImage(url: URL(string: artwork.img)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit) // 잘리지 않게 전체 다 보여줌
            } placeholder: {
                Rectangle().fill(Color.black.opacity(0.03))
                    .frame(height: width) // 로딩 중에도 영역 확보
            }
            .frame(width: width) // 너비만 고정, 높이는 이미지 비율에 따라 자동 결정
            .background(Color.white.opacity(0.4)) // 미세한 배경으로 이미지 경계선 정리
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
            
            // 정보 영역
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title.uppercased()).font(.system(size: 11, weight: .bold))
                Text(artwork.artist).font(.system(size: 10)).foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - 개별 작품 셀 (비율 조정 추가)
struct ArtworkCell: View {
    let artwork: (title: String, artist: String, img: String)
    let width: CGFloat
    var isLarge: Bool = false
    var ratio: CGFloat = 1.0 // 가로 대비 세로 비율
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: artwork.img)) { i in
                i.resizable().aspectRatio(contentMode: .fill)
            } placeholder: { Color.gray.opacity(0.1) }
            .frame(width: width, height: width * ratio) // 💡 비율에 따른 높이 계산
            .cornerRadius(isLarge ? 4 : 12)
            .clipped()
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title.uppercased())
                    .font(.system(size: isLarge ? 13 : 10, weight: .bold))
                    .foregroundColor(.black)
                Text(artwork.artist)
                    .font(.system(size: isLarge ? 11 : 9))
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - HELPER STYLES

extension View {
    // 통합 배경 스타일: 인자로 색상을 받습니다. 기본값은 .black
    func magazineBgStyle(color: Color = .black) -> some View {
        self.font(.custom("LibreBaskerville-Bold", size: 100)) // 사이즈 살짝 조절
            .foregroundColor(color.opacity(0.025)) // 0.02에서 0.025로 아주 살짝 올렸습니다.
            .offset(x: -10, y: 150)
            .zIndex(0) // 가장 뒤로 보내기
    }
    
    func tagStyle() -> some View {
        self.font(.system(size: 11, weight: .bold)).kerning(2).foregroundColor(Color(red: 0, green: 0.28, blue: 0.67))
    }
    
    func titleStyle() -> some View {
        self.font(.custom("LibreBaskerville-Bold", size: 32)).lineSpacing(4)
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

// (EdgeBorder 구조체는 이전과 동일)
struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            let x = rect.minX; let y = rect.minY
            let w = rect.width; let h = rect.height
            switch edge {
            case .top: path.addRect(CGRect(x: x, y: y, width: w, height: width))
            case .bottom: path.addRect(CGRect(x: x, y: y + h - width, width: w, height: width))
            case .leading: path.addRect(CGRect(x: x, y: y, width: width, height: h))
            case .trailing: path.addRect(CGRect(x: x + w - width, y: y, width: width, height: h))
            }
        }
        return path
    }
}


// 세로 회전 보정을 위한 헬퍼 모디파이어
struct VerticalPageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(-90))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
