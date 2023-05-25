struct GalleryData: Codable {
    let photos: Photos
    
    // Represents the gallery data containing photos
    struct Photos: Codable {
        let page: Int        // The current page number
        let pages: Int       // The total number of pages
        let perPage: String
        let total: Int       // The total number of photos
        let photo: [Photo]
    }
    
    // Represents a photo in the gallery
    struct Photo: Codable {
        let id: String
        let secret: String   // The secret key of the photo
        let server: String   // The server hosting the photo
        let farm: Int        // The farm ID associated with the photo
        let title: String
        
        // Computed property representing the URL of the photo
        var photoURL: String {
            return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        }
    }
}
