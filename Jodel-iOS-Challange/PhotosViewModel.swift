//
//  PhotosViewModel.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 24.04.2023.
//

import ImageSlideshow

class PhotosViewModel{
    
    let photos: Box<Photos?> = Box(nil) // no image initially
    
    
    let dispatchGroup = DispatchGroup()
    
    func getPics(page : String) {
        let endPoint = Endpoint.gallery(page: page)
        
        APIManager.shared.getJSON(url: endPoint.url) { (result: Result<Photos, APIManager.APIError>) in
            switch result {
            case let .success(pics):
                self.photos.value = pics
                
            case let .failure(error):
                switch error {
                case let .error(errorString):
                    print(errorString)
                }
            }
        }
        dispatchGroup.leave()
    }
}
