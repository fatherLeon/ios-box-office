//
//  MovieRakingViewModel.swift
//  BoxOffice
//
//  Created by 강민수 on 2023/09/19.
//

import Foundation

final class MovieRankingViewModel {
    var rankingViewType: RankingViewType = .list
    var dataManager: RankingManager?
    var boxofficeDate: Date {
        didSet {
            dataManager = RankingManager(date: boxofficeDate)
        }
    }
    
    init() {
        self.boxofficeDate = Date.yesterday ?? Date()
        dataManager = RankingManager(date: boxofficeDate)
    }
    
    func fetchBoxofficeData(_ handler: @escaping (Result<[InfoObject], Error>) -> Void) {
        dataManager?.fetchRanking(handler: handler)
    }
}
