//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 2023/04/03.
//

import UIKit
import RxSwift

final class MovieDetailViewController: UIViewController {
    
    // MARK: ViewModel
    private let viewModel: MovieDetailViewModel
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let posterImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let descStackView = DescStackView()
    private let loadingView = UIActivityIndicatorView()
    
    init(movieName: String, movieCode: String) {
        self.viewModel = MovieDetailViewModel(movieName: movieName, movieCode: movieCode)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        binding()
    }
    
    private func binding() {
        viewModel.movieData
            .observe(on: MainScheduler.instance)
            .subscribe { data in
                let infoUIModel = MovieInfoUIModel(data: data.movieInfoResult.movieInfo)
                
                self.descStackView.updateTextLabel(infoUIModel)
            }
            .disposed(by: disposeBag)
        
        viewModel.imageInfo
            .observe(on: MainScheduler.instance)
            .subscribe { (image, size) in
                self.posterImageView.image = image
                self.configureImageWidthConstraint(size: size)
            }
            .disposed(by: disposeBag)
        
        viewModel.isFetching
            .observe(on: MainScheduler.instance)
            .subscribe { flag in
                if flag {
                    self.startLoading()
                } else {
                    self.stopLoading()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func startLoading() {
        loadingView.startAnimating()
        posterImageView.isHidden = true
        descStackView.isHidden = true
    }
    
    private func stopLoading() {
        self.loadingView.stopAnimating()
        self.posterImageView.isHidden = false
        self.descStackView.isHidden = false
    }
}

// MARK: - UI
extension MovieDetailViewController {
    private func configureImageWidthConstraint(size: CGSize) {
        let width = CGFloat(size.width)
        let height = CGFloat(size.height)
        
        posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: height / width).isActive = true
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.movieName
        
        configureScrollView()
        configurePosterImageView()
        configureDescStackView()
        configureActivityIndicatorView()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func configurePosterImageView() {
        scrollView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            posterImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5)
        ])
    }
    
    private func configureDescStackView() {
        scrollView.addSubview(descStackView)
        
        NSLayoutConstraint.activate([
            descStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            descStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            descStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            descStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func configureActivityIndicatorView() {
        loadingView.center = view.center
        loadingView.style = .large
        
        view.addSubview(loadingView)
    }
}
