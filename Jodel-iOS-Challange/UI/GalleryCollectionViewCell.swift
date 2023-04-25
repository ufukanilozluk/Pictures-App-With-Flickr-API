//
//  GalleryCollectionViewCell.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 23.04.2023.
//

import ImageSlideshow
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var picture: ImageSlideshow!
    weak var parentViewController: UIViewController?

    static let reuseIdentifier: String = "GalleryCell"

    func set(data: GalleryData.Photos.Photo, indexPath: IndexPath, parentVC: UIViewController) {
        title.text = data.title
        addPics(url: data.photoUrl, on: picture)
        parentViewController = parentVC
    }

    func addPics(url: String, on view: ImageSlideshow) {
        let alamofireSource: [AlamofireSource] = [AlamofireSource(urlString: url)!]
        view.setImageInputs(alamofireSource)
        view.contentScaleMode = UIView.ContentMode.scaleToFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        picture.addGestureRecognizer(gestureRecognizer)
    }

    @objc func didTap() {
        guard let parentViewController = parentViewController else { return }
        picture.presentFullScreenController(from: parentViewController)
    }

    //    sliderImageView.currentPageChanged = { page in
    //        // do whatever you want eg:
    //        self.sliderOverviewLabel.text = self.upcomingMovies[page].overview
    //        self.sliderTitleLabel.text = self.upcomingMovies[page].original_title
    //    }
    //
    //    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    //    sliderImageView.addGestureRecognizer(gestureRecognizer)
    // }
    //
    // @objc func didTap() {
    //    let index = sliderImageView.currentPage
    //    performSegue(withIdentifier: goToDetailSegue, sender: nowPlayingMovies[index].id)
}
