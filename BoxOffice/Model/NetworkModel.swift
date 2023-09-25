//
//  BoxofficeInfo.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/03/22.
//

import Foundation

struct NetworkModel: NetworkingProtocol {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func search(request: URLRequest, completion: @escaping (Result<Data, BoxofficeError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            if let boxofficeError = checkError(response, error) {
                completion(.failure(boxofficeError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.incorrectDataTypeError))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
        
        return task
    }
    
    func checkError(_ response: URLResponse?, _ error: Error?) -> BoxofficeError? {
        guard error == nil else {
            return .sessionError
        }
        
        guard let response = response,
              let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return .responseError
        }
        
        return nil
    }
}
