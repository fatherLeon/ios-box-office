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
    var boxofficeDate: BehaviorSubject<Date>
    var navigationTitleText: BehaviorSubject<String>
    var disposeBag = DisposeBag()
    
    init() {
        let initialDate = Date.yesterday ?? Date()
        self.boxofficeDate = BehaviorSubject(value: initialDate)
        self.navigationTitleText = BehaviorSubject(value: Date.dateFormatter.string(from: initialDate))
        self.dataManager = RankingManager(date: initialDate)
        
        binding()
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
    
    private func binding() {
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
        
        boxofficeDate
            .subscribe { date in
                self.dataManager = RankingManager(date: date)
                self.navigationTitleText.onNext(Date.dateFormatter.string(from: date))
            }
            .disposed(by: disposeBag)
    }
}
