//
//  BoxofficeInfo.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/03/22.
//

import Foundation

class Cache {
    
    static let `default` = Cache(urlCache: .shared)
    
    private let urlCache: URLCache
    
    init(urlCache: URLCache) {
        self.urlCache = urlCache
    }
    
    func save(cachedResponse: CachedURLResponse, request: URLRequest) {
        urlCache.storeCachedResponse(cachedResponse, for: request)
    }
    
    func search(request: URLRequest) -> CachedURLResponse? {
        let storedCache = urlCache.cachedResponse(for: request)
        
        return storedCache
    }
}

struct NetworkModel: NetworkingProtocol {
    private let session: URLSession
    private let cache = Cache.default
    
    init(session: URLSession) {
        self.session = session
    }
    
    func search(request: URLRequest, completion: @escaping (Result<Data, BoxofficeError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.sessionError))
                return
            }
            
            guard let response = response,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.incorrectDataTypeError))
                return
            }
            
            let cahcedResponse = CachedURLResponse(response: response, data: data)
            cache.save(cachedResponse: cahcedResponse, request: request)
            
            completion(.success(data))
        }
        
        guard let storedData = cache.search(request: request) else {
            task.resume()
            return task
        }
        
        completion(.success(storedData.data))
        
        return task
    }
}
