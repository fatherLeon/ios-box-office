//
//  NetworkingProtocol.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/03/28.
//

import RxSwift
import Foundation

protocol NetworkingProtocol {
    init(session: URLSession)
    
    func search(request: URLRequest, completion: @escaping (Result<Data, BoxofficeError>) -> Void) -> URLSessionDataTask
    func searchByRx(_ request: URLRequest) -> Observable<Data>
}
