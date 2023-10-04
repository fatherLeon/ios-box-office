//
//  MovieRankingViewController.swift
//  BoxOffice
//
//  Created by Andrew, 레옹아범 on 13/01/23.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieRankingViewController: UIViewController {
    
    // MARK: ViewModel
    private let viewModel = MovieRankingViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: UI Properties
    private let loadingView = UIActivityIndicatorView()
    private let refreshController = UIRefreshControl()
    private let changedSceneBarButtonItem = UIBarButtonItem()
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        startLoadingView()
        bindingByUiComponents()
        fetchBoxofficeData()
    }
    
    private func bindingByUiComponents() {
        viewModel.rankingData
            .bind(to: self.collectionView!.rx.items(cellIdentifier: "MovieRankingListCell", cellType: MovieRankingListCell.self)) { (index, data, cell) in
                let uiModel = CellUIModel(data: data)
                
                cell.updateLabelText(for: uiModel)
            }
            .disposed(by: self.disposeBag)
        
        viewModel.isFetching
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.stopLoadingView()
                self.collectionView?.refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        collectionView?.rx.modelSelected(InfoObject.self)
            .subscribe(onNext: { data in
                let nextViewController = MovieDetailViewController(movieName: data.name, movieCode: data.code)
                
                self.navigationController?.pushViewController(nextViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { _ in
                let calendarVC = CalendarViewController()
                
                calendarVC.delegate = self
                calendarVC.selectedDate = (try? self.viewModel.boxofficeDate.value()) ?? Date()
                
                self.present(calendarVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshController.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                self.fetchBoxofficeData()
            }
            .disposed(by: disposeBag)
        
        changedSceneBarButtonItem.rx.tap
            .subscribe { _ in
                self.showChangeScreenModeAlert()
            }
            .disposed(by: disposeBag)
        
        viewModel.navigationTitleText
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func fetchBoxofficeData() {
        viewModel.fetchBoxofficeDataByRx()
    }

    private func startLoadingView() {
        self.loadingView.startAnimating()
    }
    
    private func stopLoadingView() {
        self.loadingView.stopAnimating()
    }
    
    private func showChangeScreenModeAlert() {
        let alert = UIAlertController(title: "화면모드변경",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: try? viewModel.rankingViewType.value().anotherTitle, style: .default, handler: { [weak self] _ in
            switch try? self?.viewModel.rankingViewType.value() {
            case .list:
                guard let iconLayout = self?.makeCollectionViewIconLayout() else { return }
                self?.viewModel.rankingViewType.onNext(.icon)
                self?.changeCollectionViewLayout(layout: iconLayout)
            case .icon:
                guard let listLayout = self?.makeCollectionViewListLayout() else { return }
                self?.viewModel.rankingViewType.onNext(.list)
                self?.changeCollectionViewLayout(layout: listLayout)
            default:
                return
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

// MARK: ChangedDateDelegate
extension MovieRankingViewController: ChangedDateDelegate {
    func changeDate(_ date: Date) {
        startLoadingView()
        viewModel.boxofficeDate.onNext(date)
        fetchBoxofficeData()
    }
}

// MARK: UI
extension MovieRankingViewController {
    
    private func makeCollectionViewListLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    private func makeCollectionViewIconLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated( view.frame.height / 4))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(view.frame.height / 4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func changeCollectionViewLayout(layout: UICollectionViewCompositionalLayout) {
        collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let layout = makeCollectionViewListLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(MovieRankingListCell.self, forCellWithReuseIdentifier: "MovieRankingListCell")
        collectionView?.register(MovieRankingIconCell.self, forCellWithReuseIdentifier: "MovieRankingIconCell")
        
        configureCollectionViewLayout()
        configureLoadingView()
        configureNavigationItems()
        configureRefreshController()
        createToolbar()
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureLoadingView() {
        loadingView.center = view.center
        loadingView.style = .large
        
        view.addSubview(loadingView)
    }
    
    private func configureNavigationItems() {
        let rightBarButtonItem = UIBarButtonItem()
        
        rightBarButtonItem.title = "날짜 선택"
        rightBarButtonItem.style = .plain
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureRefreshController() {
        collectionView?.refreshControl = refreshController
    }
        
    private func createToolbar() {
        navigationController?.setToolbarHidden(false, animated: true)
        
        let flexibleItem = UIBarButtonItem(systemItem: .flexibleSpace)
        let barButtonItem = self.changedSceneBarButtonItem
        
        barButtonItem.title = "화면 전환"
        barButtonItem.style = .plain
        
        setToolbarItems([flexibleItem, barButtonItem, flexibleItem], animated: true)
    }
}
