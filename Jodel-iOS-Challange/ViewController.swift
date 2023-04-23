//
//  ViewController.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 23.04.2023.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
            galleryCollectionView.dataSource = self
    
    }

}

//extension GalleryViewController : UICollectionViewDelegate,UICollectionViewDataSource{
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////         0
////    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////          return
////    }
//
//
//}

