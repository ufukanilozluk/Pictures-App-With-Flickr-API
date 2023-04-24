//
//  PictureModel.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 23.04.2023.
//

struct GalleryData: Codable{
    var photos : Photos
}

extension GalleryData {
    struct Photos : Codable {
        var page: String
        var pages: Int
        var total : Int
        var perpage: String
        var photo: [Photo]
    }
    
}


extension GalleryData.Photos {
    struct Photo : Codable {
        var id: String
        var secret: String
        var server: String
        var farm: Int
        var title: String
        var photoUrl : String {
        "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        }
    }
}
