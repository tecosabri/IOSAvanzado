//
//  DetailViewModel.swift
//  DragonBallMVC
//
//  Created by Ismael Sabri Pérez on 30/7/22.
//

import Foundation

protocol DetailViewModelProtocol: AnyObject {
    func onViewLoad()
}

class DetailViewModel {
    // MARK: - Public properties
    var detailImage: String?
    var detailName: String?
    var detailDescription: String?
    var dateShow: String?

    // MARK: - Private properties
    private weak var detailViewDelegate: DetailViewControllerProtocol?
    
    // MARK: - Lifecycle
    init(detailViewDelegate: DetailViewControllerProtocol?, withHero hero: Hero, shownOn dateShown: String) {
        self.detailViewDelegate = detailViewDelegate
        detailImage = hero.photo
        detailName = hero.name
        detailDescription = hero.descript
        dateShow = "\(detailName ?? "This hero") has been spotted on \n \(dateShown)"
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    func onViewLoad() {
        guard let detailImage = detailImage,
              let detailName = detailName,
              let detailDescription = detailDescription,
              let dateShow = dateShow
        else { return}
        detailViewDelegate?.update(detailImage: detailImage)
        detailViewDelegate?.update(detailName: detailName)
        detailViewDelegate?.update(detailDescription: detailDescription)
        detailViewDelegate?.update(dateShow: dateShow)
    }
}
