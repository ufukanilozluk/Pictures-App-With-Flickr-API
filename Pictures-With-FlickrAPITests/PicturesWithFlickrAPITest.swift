//
//  PicturesWithFlickrAPITest.swift
//  Pictures-With-FlickrAPITests
//
//  Created by Ufuk Anıl Özlük on 8.12.2023.
//

import XCTest
@testable import Pictures_With_FlickrAPI

final class PicturesWithFlickrAPITests: XCTestCase {
  func testJsonCanBeParsed() throws {
    guard let pathString = Bundle(for: type(of: self)).path(forResource: "Test", ofType: "json") else {
      fatalError("Json not found")
    }
    guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
      fatalError("Unable to convert json to String")
    }
    guard let jsonData = json.data(using: .utf8) else {
      fatalError("Encoding error")
    }
    guard let galleryData = try? JSONDecoder().decode(GalleryData.self, from: jsonData) else {
      fatalError("Decoding error")
    }

    XCTAssertEqual("Color", galleryData.photos.photo[0].title)
    XCTAssertEqual("Owens River and Sea Grass", galleryData.photos.photo[1].title)
    }
}
