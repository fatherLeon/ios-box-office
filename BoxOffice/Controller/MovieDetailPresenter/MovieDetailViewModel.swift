//
//  MovieDetailViewModel.swift
//  BoxOffice
//
//  Created by 강민수 on 2023/09/19.
//

import UIKit
import RxSwift

final class MovieDetailViewModel {
    let movieName: String
    private let movieCode: String
    var movieData: PublishSubject<MovieInfoObject> = PublishSubject()
    var imageInfo: PublishSubject<(UIImage, CGSize)> = PublishSubject()
    var isFetching: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    private var disposeBag = DisposeBag()
    
    private var dataManager: MovieDescManager
    
    init(movieName: String, movieCode: String) {
        self.movieName = movieName
        self.movieCode = movieCode
        self.dataManager = MovieDescManager(movieCode: movieCode, movieName: movieName)
        
        binding()
        
        fetchDataByRx()
        fetchImageByRx()
    }
    
    private func binding() {
        Observable
            .combineLatest(movieData, imageInfo)
            .map { (movieData, movieImageInfo) in
                if movieImageInfo.0.pngData() == nil {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: isFetching)
            .disposed(by: disposeBag)
    }
    
    func fetchData(_ handler: @escaping (Result<MovieInfoObject, BoxofficeError>) -> Void) {
        dataManager.boxofficeInfo.fetchData(handler: handler)
    }
    
    func fetchImage(_ handler: @escaping (Result<(UIImage, CGSize), BoxofficeError>) -> Void) {
        dataManager.fetchMoviePosterImage(handler: handler)
    }
    
    func fetchDataByRx() {
        dataManager.boxofficeInfo.fetchDataByRx(by: MovieInfoObject.self)
            .take(1)
            .bind(to: self.movieData)
            .disposed(by: disposeBag)
    }
    
    func fetchImageByRx() {
        dataManager.fetchMoviePosterImageByRx()
            .take(1)
            .bind(to: imageInfo)
            .disposed(by: disposeBag)
    }
}
