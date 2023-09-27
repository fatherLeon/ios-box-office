//
//  MovieRakingViewModel.swift
//  BoxOffice
//
//  Created by 강민수 on 2023/09/19.
//

import RxSwift
import RxRelay
import Foundation

final class MovieRankingViewModel {
    private var dataManager: RankingManager?
    var rankingViewType: BehaviorSubject<RankingViewType> = BehaviorSubject(value: .list)
    var rankingData: BehaviorRelay<[InfoObject]> = BehaviorRelay(value: [])
    var isFetching: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var disposeBag = DisposeBag()
    var boxofficeDate: Date {
        didSet {
            dataManager = RankingManager(date: boxofficeDate)
        }
    }
    var navigationTitleText: String {
        return Date.dateFormatter.string(from: self.boxofficeDate)
    }
    
    init() {
        self.boxofficeDate = Date.yesterday ?? Date()
        dataManager = RankingManager(date: boxofficeDate)
        
        rankingData
            .map { data in
                if data.count > 0 {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: isFetching)
            .disposed(by: disposeBag)
    }
    
    func fetchBoxofficeData(_ handler: @escaping (Result<[InfoObject], Error>) -> Void) {
        dataManager?.fetchRanking(handler: handler)
    }
    
    func fetchBoxofficeDataByRx() {
        guard let manager = dataManager else { return }
        
        manager.fetchRankingByRx()
            .take(1)
            .bind(to: rankingData)
            .disposed(by: self.disposeBag)
    }
}
