//
//  PictureModel.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 23.04.2023.
//


struct Photos : Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photo: [Photo]
}

extension Photos {
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


