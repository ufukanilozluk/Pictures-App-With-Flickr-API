//
//  PhotosViewModel.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 24.04.2023.
//

import ImageSlideshow

class PhotosViewModel {
    let photos: Box<GalleryData.Photos?> = Box(nil)

    func getPics(page: String, closure: @escaping () -> Void) {
        let endPoint = Endpoint.gallery(page: page)

        APIManager.shared.getJSON(url: endPoint.url) { (result: Result<GalleryData, APIManager.APIError>) in
            switch result {
            case let .success(pics):
                self.photos.value = pics.photos
                closure()

            case let .failure(error):
                switch error {
                case let .error(errorString):
                    print(errorString)
                }
            }
        }
    }
}