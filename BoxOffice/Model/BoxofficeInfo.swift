//
//  BoxofficeInfo.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/03/28.
//

import UIKit
import RxSwift

final class BoxofficeInfo<T> {
    private let apiType: APIType
    private let model: NetworkingProtocol
    private var task: URLSessionDataTask?
    private var isRunningOnlyOneTask: Bool
    
    init(apiType: APIType, model: NetworkingProtocol, isRunningOnlyOneTask: Bool = false) {
        self.apiType = apiType
        self.model = model
        self.isRunningOnlyOneTask = isRunningOnlyOneTask
    }
    
    private func decodeData(_ data: Data) -> T? where T: Decodable {
        do {
            let decodingData = try JSONDecoder().decode(T.self, from: data)
            return decodingData
        } catch {
            return nil
        }
    }
    
    private func makeRequest(url: URL) -> URLRequest? {
        if isRunningOnlyOneTask {
            cancelTask()
        }
        
        var urlRequest = URLRequest(url: url)
        
        guard let header = apiType.header else {
            return urlRequest
        }
        
        urlRequest.addValue(header, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    private func cancelTask() {
        task?.cancel()
    }
    
    func fetchData(handler: @escaping (Result<T, BoxofficeError>) -> Void) where T: Decodable {
        guard let url = apiType.receiveUrl(),
              let request = makeRequest(url: url) else {
            handler(.failure(.urlError))
            return
        }
        
        task = model.search(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodingData = self?.decodeData(data) else {
                    handler(.failure(.decodingError))
                    return
                }
                handler(.success(decodingData))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func fetchImage(url: URL, handler: @escaping (Result<UIImage, BoxofficeError>) -> Void) {
        guard let request = makeRequest(url: url) else {
            handler(.failure(.urlError))
            return
        }
        
        task = model.search(request: request, completion: { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    handler(.failure(.decodingError))
                    return
                }
                handler(.success(image))
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
    
    func fetchDataByRx(by type: T.Type) -> Observable<T> where T: Decodable {
        return Observable.create { observer in
            guard let url = self.apiType.receiveUrl(),
                  let request = self.makeRequest(url: url) else {
                observer.onError(BoxofficeError.urlError)
                return Disposables.create()
            }
            
            let observable = self.model.searchByRx(request)
                .take(1)
                .map { data in
                    let jsonDecoder = JSONDecoder()
                    
                    guard let decodingData = try? jsonDecoder.decode(type, from: data) else {
                        observer.onError(BoxofficeError.decodingError)
                        
                        return
                    }
                    
                    observer.onNext(decodingData)
                    observer.onCompleted()
                }
            
            return Disposables.create()
        }
    }
    
    func fetchImageByRx(url: URL) -> Observable<UIImage> {
        return Observable.create { observer in
            guard let url = self.apiType.receiveUrl() else {
                
                observer.onError(BoxofficeError.urlError)
                
                return Disposables.create()
            }
            
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                
                observer.onError(BoxofficeError.imageVaildError)
                
                return Disposables.create()
            }
            
            observer.onNext(image)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
