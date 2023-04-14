//
//  BoxofficeInfo.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/03/22.
//

import Foundation

struct NetworkModel: NetworkingProtocol {
    private let session: URLSession
    private let cache = Cache.shared
    
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
            cache.save(response: cahcedResponse, request: request)
            completion(.success(data))
        }
        
        guard let searchData = cache.search(urlRequest: request) else {
            task.resume()
            return task
        }

        completion(.success(searchData.data))
        return task
    }
}

class Cache {
    static let shared = Cache(urlCache: .shared)
    let urlCache: URLCache
    
    init(urlCache: URLCache) {
        self.urlCache = urlCache
    }
    
    func search(urlRequest: URLRequest) -> CachedURLResponse? {
        let cache = urlCache.cachedResponse(for: urlRequest)
        
        return cache
    }
    
    func save(response: CachedURLResponse, request: URLRequest) {
        urlCache.storeCachedResponse(response, for: request)
    }
    
}
