//
//  ViewController.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 23.04.2023.
//

import UIKit
import SkeletonView

class GalleryViewController: UIViewController {
    @IBOutlet var galleryCollectionView: UICollectionView!
    
    var photos : [Photos.Photo]?
    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
    }
}



extension GalleryViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        GalleryCollectionViewCell.reuseIdentifier
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath)

        if let cell = cell as? GalleryCollectionViewCell {
            if let rowData = photos?[indexPath.row] {
                cell.set(data: rowData, indexPath: indexPath)
            }
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == pokemon.count - 1 {
       //        if let nextURL {
       //            anasayfaVModel.getPokemon(url: nextURL)
       //        }
       //    }
    }
}

func setBindings() {
    viewModel.bigIcon.bind { [weak self] bigIcon in
        DispatchQueue.main.async {
            self?.imgWeatherMain.image = bigIcon
        }
    }

    viewModel.description.bind { [weak self] description in
        DispatchQueue.main.async {
            self?.lblDescription.text = description
        }
    }

    viewModel.humidity.bind { [weak self] humidity in
        DispatchQueue.main.async {
            self?.lblHumidity.text = humidity
        }
    }

    viewModel.wind.bind { [weak self] wind in
        DispatchQueue.main.async {
            self?.lblWind.text = wind
        }
    }

    viewModel.temperature.bind { [weak self] temperature in

        DispatchQueue.main.async {
            self?.lblTemperature.text = temperature
        }
    }

    viewModel.visibility.bind { [weak self] visibility in

        DispatchQueue.main.async {
            self?.lblVisibility.text = visibility
        }
    }
    

    viewModel.pressure.bind { [weak self] pressure in

        DispatchQueue.main.async {
            self?.lblPressure.text = pressure
        }
    }

    viewModel.date.bind { [weak self] date in

        DispatchQueue.main.async {
            self?.lblDate.text = date
        }
    }

    viewModel.date.bind { [weak self] date in

        DispatchQueue.main.async {
            self?.lblDate.text = date
        }
    }

    viewModel.weatherData.bind { [weak self] weatherData in
        self?.dataWeather = weatherData
    }

    viewModel.weeklyWeatherData.bind { [weak self] weeklyWeatherData in
        self?.weeklyWeather = weeklyWeatherData
    }
}

@objc func didPullToRefresh() {
    fetchData(for: selectedCity!)
    addSkeleton()
}

func configUI() {
    weeklyWeatherTV.dataSource = self
    weeklyWeatherTV.delegate = self
    scrollViewAnasayfa.delegate = self
    dailyWeatherCV.delegate = self
    dailyWeatherCV.dataSource = self

    refreshControl.attributedTitle = NSAttributedString(string: "Updating")
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    scrollViewAnasayfa.addSubview(refreshControl)

    // for skeletonview
    weeklyWeatherTV.estimatedRowHeight = 50
    
}

func updateUI() {
    setBindings()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.dailyWeatherCV.reloadData()
        self.weeklyWeatherTV.reloadData()
        self.refreshControl.endRefreshing()
        self.removeSkeleton()
    }
}
