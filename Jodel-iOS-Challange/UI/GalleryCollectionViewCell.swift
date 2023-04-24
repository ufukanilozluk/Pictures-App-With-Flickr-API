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

    static let reuseIdentifier: String = "GalleryCell"

    func set(data: Photos.Photo, indexPath: IndexPath) {
        title.text =  data.title
        addPics(url:data.photoUrl, on: picture)
    }

     func addPics(url: String, on view: ImageSlideshow) {
        var alamofireSource: [AlamofireSource] = [AlamofireSource(urlString: url)!]
        view.setImageInputs(alamofireSource)
        view.contentScaleMode = UIView.ContentMode.scaleToFill
     }
}
