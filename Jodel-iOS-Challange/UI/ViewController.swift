//
//  ViewController.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 23.04.2023.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet var galleryCollectionView: UICollectionView!

//    var nextURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
    }
}

//func addPics(_ data: [String], on view: ImageSlideshow) {
//    var alamofireSource: [AlamofireSource] = []
//    for pic in data {
//        alamofireSource.append(AlamofireSource(urlString: pic)!)
//    }
//
//    view.setImageInputs(alamofireSource)
//    view.contentScaleMode = UIView.ContentMode.scaleToFill
//}
//extension GalleryViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
//    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        AnasayfaDailyWeatherCVCell.reuseIdentifier
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        dataWeather?.count ?? 0
//    }
//
//    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        dataWeather?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnasayfaDailyWeatherCVCell.reuseIdentifier, for: indexPath)
//
//        if let cell = cell as? AnasayfaDailyWeatherCVCell {
//            if let rowData = dataWeather?[indexPath.row] {
//                cell.set(data: rowData, indexPath: indexPath)
//            }
//        }
//
//        return cell
//    }
//}


// }
//
//func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    if indexPath.row == pokemon.count - 1 {
//        if let nextURL {
//            anasayfaVModel.getPokemon(url: nextURL)
//        }
//    }
//}
