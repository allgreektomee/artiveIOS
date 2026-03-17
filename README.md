# 🎨 Artive for iOS

Artive는 작품을 감상하고 작업 히스토리를 기록 및 공유하는 iOS 애플리케이션입니다.


## 🛠️ 기술 스택 (Core Technologies)

UI Framework: SwiftUI
Asynchronous: Combine
Architecture: MVVM + Custom DI
Networking: URLSession
API Endpoint Management: Enum-based Router (ArtiveAPI)
Secure Storage: Keychain

## 🏛️ 아키텍처 (Architecture)

  본 프로젝트는 Apple의 최신 개발 패러다임을 적극적으로 활용한 MVVM (Model-View-ViewModel) 아키텍처를 기반으로 설계되었습니다. 각 컴포넌트 간의 결합도를 낮추고 테스트 용이성을 높이기 위해 자체 구현한 DI 컨테이너를 통해 의존성을 주입합니다.

## 주요 레이어 (Key Layers)

**View**

역할: SwiftUI를 사용하여 UI를 선언적으로 구성하고, 사용자의 입력을 받아 ViewModel에 전달합니다.

특징: ViewModel의 상태(@Published 프로퍼티)를 구독(@StateObject, @ObservedObject)하여 UI를 자동으로 갱신합니다. 자체적인 비즈니스 로직을 포함하지 않습니다.

주요 파일: ArtworkView.swift, LoginView.swift, ArtworkRow.swift


**ViewModel**

역할: View에 표시될 데이터(상태)를 관리하고, View로부터 받은 이벤트를 처리합니다. Service 레이어와 통신하여 비즈니스 로직을 수행합니다.

특징: @Published 프로퍼티 래퍼를 통해 View가 관찰할 수 있는 상태를 노출합니다.

주요 파일: ArtworkViewModel.swift, UserViewModel.swift

**Service**
역할: 앱의 핵심 비즈니스 로직을 캡슐화합니다. 여러 API를 조합하거나 데이터를 가공하는 등의 역할을 수행합니다.

특징: APIService를 주입받아 네트워크 통신을 수행하며, ViewModel에 필요한 데이터를 가공하여 제공합니다.

주요 파일: ArtworkService.swift, UserService.swift


**Model & Network**

역할: 서버와 통신하여 데이터를 가져오고, 앱에서 사용할 데이터 모델을 정의합니다.

특징:
APIService: URLSession과 Combine을 사용하여 모든 네트워크 요청을 처리하는 중앙 집중식 클래스입니다. 토큰 자동 주입, 공통 에러 처리 등의 역할을 담당합니다.

ArtiveAPI: API 엔드포인트를 enum으로 관리하여 타입-세이프(Type-safe)하게 URL을 생성합니다.

AuthManager: Keychain을 사용하여 사용자의 인증 토큰을 안전하게 관리합니다.

주요 파일: APIService.swift, ArtiveAPI.swift, AuthManager.swift, ArtworkResponse.swift 등


## 의존성 주입 (Dependency Injection)

외부 라이브러리 없이 직접 구현한 **서비스 로케이터(Service Locator) 패턴**의 DI 컨테이너를 사용합니다.


DependencyContainer.swift: 싱글톤으로 구현된 컨테이너로, 앱 생명주기 동안 필요한 서비스 인스턴스들을 저장합니다.

등록(Register): 앱 시작 시점(artiveApp.swift)에 필요한 서비스의 구현체를 프로토콜 타입으로 등록합니다.


    // artiveApp.swift
    
    init() {
    
    DependencyContainer.shared.register(type: APIServiceProtocol.self, component: APIService())
    
    DependencyContainer.shared.register(type: ArtworkServiceProtocol.self, component: ArtworkService())
    
    }

사용(Resolve): @Inject 프로퍼티 래퍼(Property Wrapper)를 통해 필요한 곳에서 의존성을 주입받습니다.


    // ArtworkService.swift
    
    class ArtworkService: ArtworkServiceProtocol {
    
    @Inject var api: APIServiceProtocol // 컨테이너가 등록된 APIService를 주입
    
    ...
    
    }

## 🌊 데이터 흐름 (Data Flow)

**View**: onAppear 시점에 viewModel.getArtworkList() 호출

 - ArtworkView: 화면이 나타나면(onAppear) viewModel.getArtworkList()를 호출합니다.

**ViewModel**: 로딩 상태 업데이트 및 ArtworkService 호출

 - ArtworkViewModel: isLoading 상태를 true로 변경하고, 주입받은 ArtworkService의
   getArtworkList()를 호출합니다.

**Service**: APIService를 통해 GET /artworks 요청

 - ArtworkService: 주입받은 APIService를 통해 GET /artworks API를 요청합니다.

**APIService**: URLSession 기반 비동기 통신 후 AnyPublisher 반환

 - APIService: URLSession.dataTaskPublisher를 사용하여 비동기 네트워크 요청을 수행하고, 응답을
   AnyPublisher<T, Error> 타입으로 반환합니다.

  
**ViewModel**: 결과를 구독(sink)하여 @Published 데이터 업데이트

 - ArtworkViewModel: Combine의 sink 오퍼레이터를 통해 Publisher를 구독합니다.
 - 성공 시: 응답 데이터를 @Published 프로퍼티인 artworks에 할당합니다.
 - 실패 시: 발생한 에러를 @Published 프로퍼티인 error에 할당합니다.
 - 완료 시: isLoading 상태를 false로 변경합니다.

**View**: 데이터 변화를 감지하여 리스트 자동 렌더링
 - ArtworkView: artworks 상태가 변경된 것을 감지하고, List를 자동으로 다시 그려 화면에 작품 목록을
   표시합니다. 로딩 및 에러 상태에 따라 ProgressView나 에러 메시지를 보여줍니다.
