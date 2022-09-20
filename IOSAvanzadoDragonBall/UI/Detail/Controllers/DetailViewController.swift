//
//  DetailViewController.swift
//  DragonBallMVC
//
//  Created by Ismael Sabri Pérez on 30/7/22.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject  {
    func update(detailImage image: String)
    func update(detailName name: String)
    func update(detailDescription description: String)
    func update(dateShow date: String)
}

class DetailViewController: UIViewController {
    // MARK: - Public properties
    var detailViewModel: DetailViewModelProtocol?
    
    // MARK: - IBOutlets
    @IBOutlet weak var detailDescription: UITextView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateShow: UITextView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        detailViewModel?.onViewLoad()
    }
    
    func setViewModel(withHero hero: Hero, shownOn dateShow: String) {
        detailViewModel = DetailViewModel(detailViewDelegate: self, withHero: hero, shownOn: dateShow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}

extension DetailViewController: DetailViewControllerProtocol, UIScrollViewDelegate {
    func update(detailImage image: String) {
        detailImage.setImage(url: image)
    }
    
    func update(detailName name: String) {
        detailName.text = name
    }
    
    func update(detailDescription description: String) {
        detailDescription.text = description
    }
    
    func update(dateShow date: String) {
        dateShow.text = date
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let correctedOffset = scrollView.contentOffset.y + view.safeAreaInsets.top
        imageHeightConstraint.constant = 200 - correctedOffset
    }
}

