//
//  MovieDescManager.swift
//  BoxOffice
//
//  Created by 강민수 on 2023/04/03.
//

import UIKit
import RxSwift

final class MovieDescManager {
    let boxofficeInfo: BoxofficeInfo<MovieInfoObject>
    let movieImage: BoxofficeInfo<MovieImageObject>
    var imageDocument: Document?
    
    private var disposeBag = DisposeBag()
    
    init(movieCode: String, movieName: String, session: URLSession = URLSession.shared) {
        let movieApiType = APIType.movie(movieCode)
        let movieImageApiType = APIType.movieImage(movieName)
        
        self.boxofficeInfo = BoxofficeInfo<MovieInfoObject>(apiType: movieApiType, model: NetworkModel(session: session))
        self.movieImage = BoxofficeInfo<MovieImageObject>(apiType: movieImageApiType, model: NetworkModel(session: session))
    }
    
    func fetchMoviePosterImage(handler: @escaping (Result<(UIImage, CGSize), BoxofficeError>) -> Void) {
        let dispatchGroup = DispatchGroup()
    
        dispatchGroup.enter()

        movieImage.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                guard let document = data.documents.first else {
                    return handler(.failure(.imageVaildError))
                }
                self?.imageDocument = document
                dispatchGroup.leave()
            case .failure(let error):
                handler(.failure(error))
            }
        }
    
        dispatchGroup.notify(queue: .global()) {
            guard let document = self.imageDocument else {
                return
            }
            let imageSize = CGSize(width: document.width, height: document.height)
            
            self.fetchImage(imageUrlText: document.url, imageSize: imageSize, handler: handler)
        }
    }
    
    func fetchMoviePosterImageByRx() -> Observable<(UIImage, CGSize)> {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        movieImage.fetchDataByRx(by: MovieImageObject.self)
            .subscribe { data in
                self.imageDocument = data.documents.first
                dispatchGroup.leave()
            }
            .disposed(by: disposeBag)
        
        dispatchGroup.wait()
        
        guard let document = self.imageDocument,
              let url = URL(string: document.url) else { return .error(BoxofficeError.urlError) }
        
        return movieImage.fetchImageByRx(url: url)
            .map { image in
                return (image, CGSize(width: document.width, height: document.height))
            }
    }
    
    private func fetchImage(imageUrlText: String, imageSize: CGSize, handler: @escaping (Result<(UIImage, CGSize), BoxofficeError>) -> Void) {
        guard let url = URL(string: imageUrlText) else {
            handler(.failure(.urlError))
            return
        }
        
        movieImage.fetchImage(url: url) { result in
            switch result {
            case .success(let image):
                handler(.success((image, imageSize)))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
