//
//  MovieDetailViewModel.swift
//  BoxOffice
//
//  Created by 강민수 on 2023/09/19.
//

import Foundation

final class MovieDetailViewModel {
    private let movieName: String
    private let movieCode: String
    
    init(movieName: String, movieCode: String) {
        self.movieName = movieName
        self.movieCode = movieCode
    }
}
