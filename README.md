# 박스오피스 프로젝트 🎬
> 영화진흥위원회 OPEN API, 다음 이미지 API를 사용한 오늘의 박스오피스와 영화 상세정보를 보여주는 앱

### 핵심 경험
- ✅ UnitTest를 통한 설계 검증
- ✅ URL Session 서버 통신
- ✅ Modern Collection View
    - ✅ DiffableDataSource
    - ✅ UICollectionViewListCell
    - ✅ Snapshot
    - ✅ CellRegistration
- ✅ UICalendarView
- ✅ UIToolBar


---
## 목차 📋
1. [팀원 소개](#1-팀원-소개)
2. [타임 라인](#2-타임라인)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [실행화면](#4-실행화면)
5. [트러블 슈팅](#5-트러블-슈팅)
6. [Reference](#6-Reference)

---
## 1. 팀원 소개
|레옹아범|Andrew|
|:--:|:--:|
|<img src="https://github.com/hyemory/ios-bank-manager/blob/step4/images/leon.jpeg?raw=true" width="150">|<img src="https://github.com/hyemory/ios-exposition-universelle/blob/step2/images/Andrew.png?raw=true" width="200">|
| [<img src="https://i.imgur.com/IOAJpzu.png" width="22"/> Github](https://github.com/Andrew-0411) | [<img src="https://i.imgur.com/IOAJpzu.png" width="22"/> Github](https://github.com/fatherLeon) |

## 2. 타임라인

<details><summary><big>타임라인</big></summary>
    
|날짜|진행 내용|
|---|---|
|2023-03-20(월)|API 통신을 위한 모델 타입 구현|
|2023-03-21(화)|URLSession 동작 타입 및 메소드 구현|
|2023-03-22(수)|BoxofficeError 및 APIType 구현|
|2023-03-23(목)|Model refactoring|
|2023-03-24(금)|README 작성 및 모델 타입 Test 코드 작성|
|2023-03-27(월)|Model 타입 및 메서드 분리|
|2023-03-28(화)|Test Double을 활용한 Test 코드 작성|
|2023-03-29(수)|테스트 코드 리팩토링|
|2023-03-30(목)|박스오피스 목록 화면 구현|
|2023-03-31(금)|README 작성|
|2023-04-03(월)|영화 상세 화면 구현|
|2023-04-04(화)|코드 컨벤션 및 불필요한 코드 수정|
|2023-04-05(수)|UICalendarView를 활용한 날짜선택 화면 구현|
|2023-04-06(목)|Model 및 View Controller 리팩토링|
|2023-04-07(금)|README 작성|
|2023-04-10(월)|Custom UI 수정|
|2023-04-11(화)|모드선택(UIToolbar, ActionSheet) 구현|
|2023-04-12(수)|사용자 설정에 실시간 대응할 수 있도록 Dynamic Type 구현|
|2023-04-13(목)|전체 코드 리팩토링 및 불필요한 코드 수정|
|2023-04-14(금)|README 작성|

</details>

## 3. 프로젝트 구조

### 1️⃣ 폴더 구조
```
├── BoxOffice
    ├── BoxOfficeInfo.plist
    ├── Controller
    │   ├── CalendarViewController.swift
    │   ├── MovieDetailViewController.swift
    │   └── MovieRankingViewController.swift
    ├── Extension
    │   ├── Bundle+extension.swift
    │   ├── Date+extension.swift
    │   ├── String+extension.swift
    │   ├── UILabel+extension.swift
    │   └── ViewController+extension.swift
    ├── Info.plist
    ├── Model
    │   ├── APIType.swift
    │   ├── BoxofficeError.swift
    │   ├── BoxofficeInfo.swift
    │   ├── DTO
    │   │   ├── BoxofficeDTO
    │   │   │   ├── BoxofficeResultObject.swift
    │   │   │   ├── DailyBoxofficeObject.swift
    │   │   │   └── InfoObject.swift
    │   │   ├── MovieDTO
    │   │   │   ├── MovieInfoDescObject.swift
    │   │   │   ├── MovieInfoObject.swift
    │   │   │   └── MovieInfoResultObject.swift
    │   │   └── MovieImageDTO
    │   │       └── MovieImageObject.swift
    │   ├── Manager
    │   │   ├── MovieDescManager.swift
    │   │   └── RankingManager.swift
    │   ├── NetworkModel.swift
    │   ├── RankingViewType.swift
    │   └── UIModel
    │       ├── CellUIModel.swift
    │       └── MovieInfoUIModel.swift
    ├── Protocol
    │   ├── ChangedDateDelegate.swift
    │   └── NetworkingProtocol.swift
    └── View
        ├── MovieRankingIconCell.swift
        ├── MovieRankingListCell.swift
        └── UIStackView
            ├── ContentStackView.swift
            └── DescStackView.swift
```

### 2️⃣ 클래스 다이어그램
![](https://github.com/Andrew-0411/ios-box-office/blob/step6/images/classDiagram.png?raw=true)

## 4. 실행화면

|데이터 로딩 시 로딩화면 표시|어제의 박스오피스 화면|영화상세정보 화면|
|:--:|:--:|:--:|
|<img src="https://github.com/Andrew-0411/ios-box-office/blob/step6/images/실행화면/1.gif?raw=true" width="220" height ="500">|<img src="https://github.com/Andrew-0411/ios-box-office/blob/step6/images/실행화면/3.gif?raw=true" width="220" height ="500">|<img src="https://github.com/Andrew-0411/ios-box-office/blob/step6/images/실행화면/2.gif?raw=true" width="220" height ="500">|

|특정날짜의 박스오피스 화면|다이나믹타입 적용 - 1|다이나믹타입 적용 - 2|
|:--:|:--:|:--:|
|<img src="https://github.com/Andrew-0411/ios-box-office/blob/step6/images/실행화면/4.gif?raw=true" width="220" height ="500">|<img src="https://github.com/Andrew-0411/ios-box-office/blob/step6/images/실행화면/5.gif?raw=true" width="220" height ="500">|<img src="https://github.com/Andrew-0411/ios-box-office/blob/step6/images/실행화면/6.gif?raw=true" width="220" height ="500">|

## 5. 트러블 슈팅

### 1️⃣ CellRegistration을 통한 여러 UI모드 변경

#### ❓문제점
* 리스트<->아이콘으로 변경 시 기존에는 `collectionView.register`메소드를 이용하여 두개의 cell을 등록하고 `dataSource`를 변경해주는 로직으로 UI를 변경하였습니다.

#### 📖해결한 점
* 위 문제 해결을 위하여 `CellRegistration`을 사용하여 `dataSource`내에서 현재 `viewType`을 통해 재사용 셀을 디큐해주는 방식으로 구현하였습니다.

```swift
private func createDataSource() {
    guard let collectionView = self.collectionView else { return }
    
    let listCellRegistration = UICollectionView.CellRegistration<MovieRankingListCell, InfoObject> { cell, indexPath, item in
    //....
    dataSource = UICollectionViewDiffableDataSource<RankingViewType, InfoObject>(collectionView: collectionView, cellProvider: { [self] collectionView, indexPath, itemIdentifier in
        switch self.rankingViewType {
        case .icon:
            return collectionView.dequeueConfiguredReusableCell(using: iconCellRegistration, for: indexPath, item: itemIdentifier)
        case .list:
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
        }
    })
}
```

* UI변경을 할 경우 `dataSource`는 그대로 사용하며 스냅샷을 통해 섹션 삭제와 `apply`메소드를 통하여 UI변경을 해주었습니다.


### 2️⃣ 열거형 Associated Values의 사용

#### ❓문제점
```swift
enum APIType {
    case movie
    case boxoffice
    
    func receiveUrl(interfaceValue: String) -> URL? {
        let key = Bundle.main.apiKey
        //...
    }
}
```

* 기존 URL에서 일일 박스오피스(날짜), 영화(영화 코드) 데이터를 받기 위해 한가지의 `interfaceValue`가 필요했습니다.
* 하지만 이렇게 작성할 경우 `interfaceValue`가 필요하지 않거나, 여러 개의 `interfaceValue`가 필요한 경우에는 해당 메소드를 사용하지 못하는 문제가 있었습니다.

#### 📖해결한 점
```swift
enum APIType {
    case movie(String)
    case boxoffice(String)
    
    func receiveUrl() -> URL? {
        //...
    }
}
```

* 위와 같이 열거형 케이스마다 연관 값을 부여하여 해당 케이스가 고유의 `interfaceValue`를 가지게 하고 URL에서 쉽게 사용하도록 만들었습니다.

### 3️⃣ URLProtocol 사용하여 Unit Test

#### ❓문제점
<img src="https://github.com/Andrew-0411/ios-box-office/blob/step3/images/urlsessiondatatask.png?raw=true" width="300">

- URLSessionDataTask의 init이 iOS 13 버전부터 deprecated가 되었습니다.
- 실제로 사용해보니 컴파일 경고가 나왔고 이후 버전에서도 테스트하기 어렵다고 판단했습니다.
- 다른 방법을 찾다가 URLProtocol을 사용하게 되었습니다.

#### 📖해결한 점
```swift
final class MockURLProtocolObject: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocolObject.requestHandler else {
            fatalError("handler를 응답 받지 못하였습니다")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
    }
    
    override func stopLoading() {
    }
    
}
```
- URLProtocol을 사용하여 네트워크의 요청 결과에 따른 코드 동작을 테스트를 하였습니다.
- MockURLProtocol을 구현하여 네트워크를 수행하는 객체(BoxofficeInfo)에 의존성 주입으로 URLSession을 넣어 구현하였습니다.

### 4️⃣ DataSource vs DiffableDataSource 어떤것을 사용할까?

#### ❓문제점
* DiffableDataSource로 꼭 구현할 필요는 없지만
* DataSource와 DiffableDataSource의 차이점과 왜 기존 DataSource외에 추가적으로 DiffableDataSource가 나왔는지에 대해 공부하고 어떤것을 사용할것인지에 대해 고민했습니다.

#### 📖해결법
[wwdc19 - Advances In UI Data Source](https://developer.apple.com/videos/play/wwdc2019/220)

* 위 영상 내용을 참고했습니다.
* DataSource와는 다르게 DiffableDataSource의 경우 아이템의 변화에따라 애니메이션이 추가된다는 점이 있습니다.
* IndexPath를 사용하던 DataSource와는 다르게 각각의 섹션과 아이템을 `Hashable`을 채택한 타입으로 서로 구별할 수 있어 이전에 IndexPath의 섹션과 아이템의 수에 따라서 변화를 주던 방식을 탈피할 수 있는 점 등이 있습니다.
* 위 이유와 dataSource는 ios6, diffableDataSource는 ios13에서 사용 가능하여 비교적 최근꺼인 diffableDataSource를 사용하였습니다.

### 5️⃣ Snapshot 활용

#### ❓문제점
* 새로고침을 할 경우 기존 스냅샷에 있는 데이터와 같은 데이터가 들어와 `snapshot.appendItems(movieItems)`를 해줄 경우에

```
Diffable data source detected an attempt to insert or append 10 item identifiers that already exist in the snapshot.......
```

* 위와 같이 동일한 `identifiers`가 들어와 경고가 발생하는 문제가 있었습니다.

```swift
private func applySnapshot() {
    snapshot.deleteItems(movieItems)
        
    snapshot.appendItems(movieItems)
        
    dataSource.apply(snapshot, animatingDifferences: true)
}
```

#### 📖해결법

* 위와 같이 기존에 덮어쓰기를 할 경우 기존의 항목들이 다시 원래 자리로 돌아가는데 이럴 경우 작업비용이 더 많이 든다는 추가 문구가 있어서 위 메서드에서 스냅샷 인스턴스를 만들어 `dataSource`에 `apply`하는 방법으로 구현하였습니다.

### 6️⃣ 어제 날짜를 출력하는 방법
#### ❓문제점
- Date()를 사용하면 오늘 날짜와 시간을 출력할 수 있었습니다.
- 하지만 프로젝트에서는 시간을 제외한 `어제 날짜`를 출력해야 했습니다.
- Date() 만을 사용하는 데에는 한계를 느껴서 찾아보던중 Calendar 구조체를 사용하였습니다.

#### 📖해결법
[Apple Developer: Calendar](https://developer.apple.com/documentation/foundation/calendar)
- 공식문서 `Calendar`를 참조
```swift
guard let day = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
    return Date()
}
return day
```
- Calendar에 value 옵션값을 -1로 주어서 하루전의 값을 가져오도록 해결하였습니다.

### 7️⃣ URL Components를 이용한 URL 관리
#### ❓문제점
- `URL(string:)`의 이니셜라이저는 한글, 띄어쓰기 등을 관리해주지 않아 원하는 URL을 가져오지 못하는 상황이 있었습니다.
- `URL`구조체는 이전의 RFC방법을 사용하여 파싱하므로 비교적 최신 기술인 RFC3986을 이용한 `URLComponenets`를 이용하기로 했습니다.
- `URLComponents`를 사용할 경우에도 기존과 동일하게 `URL`을 가져올 수 있고 `scheme`, `host`, `query`등을 나눠서 관리하기 편해진다는 장점이 있었습니다.

#### 📖해결법

```swift
private var scheme: String {
    switch self {
    case .movie(_), .boxoffice(_):
        return "http"
    case .movieImage(_):
        return "https"
    }
}

private var host: String {
    switch self {
    case .movie(_), .boxoffice(_):
        return "kobis.or.kr"
    case .movieImage(_):
        return "dapi.kakao.com"
    }
}

func receiveUrl() -> URL? {
    let key = Bundle.main.koficApiKey
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host

    switch self {
    case .movie(let code):
        urlComponents.path = "/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"

        let keyQuery = URLQueryItem(name: "key", value: key)
        let codeQuery = URLQueryItem(name: "movieCd", value: code)

        urlComponents.queryItems = [keyQuery, codeQuery]

        return urlComponents.url
    //.....
    }
}
```
* 위와 같이 `URLComponents`의 `scheme`, `host`, `path`, `query`등을 활용하여 조금 더 확장성 있는 코드로 개선할 수 있었습니다.

### 8️⃣ DispatchGroup을 이용한 비동기 작업들 이후 UI 일괄처리
#### ❓문제점
- `MovieDetailViewController`에서 이미지와 영화정보는 서로 다른 방식과 서버를 통해 처리하기 때문에, 이미지가 먼저 나오거나 영화 정보가 먼저 나오는 문제가 있었습니다.
- `URLSessionDataTask`를 통해 비동기로 작업을 진행하므로 끝나는 타이밍을 알 수 없어 `DispatchGroup`을 통하여 해당 두 작업이 모두 끝날 경우 UI가 나오도록 하였습니다.

#### 📖해결법

```swift
private func stopLoading() {
    dispatchGroup.notify(queue: .main) {
        self.loadingView.stopAnimating()
        self.posterImageView.isHidden = false
        self.descStackView.isHidden = false
    }
}
```
- `DispatchGroup`의 `notify`메소드를 통해 해당 그룹의 작업이 모두 끝나면 기존에 숨겨놨던 뷰를 다시 보여줌으로 동시에 UI가 보일 수 있게 구현하였습니다.

### 9️⃣ Extension과 convenience init를 사용한 반복 코드 줄이기
#### ❓문제점
```swift
let nameText = UILabel()
text.numberOfLines = 0
text.font = .boldSystemFont(ofSize: 12)
text.translatesAutoresizingMaskIntoConstraints = false
text.adjustsFontSizeToFitWidth = true
text.adjustsFontForContentSizeCategory = true

let rankingText = UILabel()
text.numberOfLines = 0
text.font = .boldSystemFont(ofSize: 12)
text.translatesAutoresizingMaskIntoConstraints = false
text.adjustsFontSizeToFitWidth = true
text.adjustsFontForContentSizeCategory = true

...
```
- 각각의 text마다 똑같은 옵션을 사용하는 경우가 많았습니다.
- 동일한 코드가 많아짐으로써 코드 전체량이 많아지고 옵션값을 수정할 때마다 매번 각각의 Label로 가서 수정을 해주어야 했습니다.

#### 📖해결법
```swift
extension UILabel {
    convenience init(fontStyle: UIFont, numberOfLine: Int = 1) {
        self.init()
        
        numberOfLines = numberOfLine
        font = fontStyle
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        adjustsFontForContentSizeCategory = true
    }
}
```
- extension을 사용해 UILabel을 확장하여 여러곳에 사용할 수 있도록 하였습니다.



## 6. Reference
- [Apple Developer: URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Apple Developer: Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [Apple Developer: UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
- [Apple Developer: Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [Apple Developer - CellRegistration](https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration)
- [Apple Developer: UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)
- [Apple Developer: URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)
- [Apple Developer: Calendar](https://developer.apple.com/documentation/foundation/calendar)
- [Apple HIG: Typography](https://developer.apple.com/design/human-interface-guidelines/foundations/typography/)
- [Apple HIG: Entering data](https://developer.apple.com/design/human-interface-guidelines/patterns/entering-data/)
- [WWDC2019: Advances in UI Data Sources](https://developer.apple.com/videos/play/wwdc2019/220)
- [WWDC2020: Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
- [WWDC2020: Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
