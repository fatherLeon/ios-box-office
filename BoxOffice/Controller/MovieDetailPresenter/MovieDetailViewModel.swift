//
//  MovieDetailViewModel.swift
//  BoxOffice
//
//  Created by 강민수 on 2023/09/19.
//

import UIKit

final class MovieDetailViewModel {
    let movieName: String
    private let movieCode: String
    
    private var dataManager: MovieDescManager
    
    init(movieName: String, movieCode: String) {
        self.movieName = movieName
        self.movieCode = movieCode
        self.dataManager = MovieDescManager(movieCode: movieCode, movieName: movieName)
    }
    
    func fetchData(_ handler: @escaping (Result<MovieInfoObject, BoxofficeError>) -> Void) {
        dataManager.boxofficeInfo.fetchData(handler: handler)
    }
    
    func fetchImage(_ handler: @escaping (Result<(UIImage, CGSize), BoxofficeError>) -> Void) {
        dataManager.fetchMoviePosterImage(handler: handler)
    }
}
