////
////  PhotosViewModel.swift
////  Jodel-iOS-Challange
////
////  Created by Ufuk Anıl Özlük on 24.04.2023.
////
//
//import Foundation
//
//class CitiesMainVModel: MainVModel {
//    let temperature = Box("")
//    let bigIcon: Box<UIImage?> = Box(nil) // no image initially
//    let description = Box("")
//    let visibility = Box("")
//    let wind = Box("")
//    let humidity = Box("")
//    let pressure = Box("")
//    let date = Box("")
//    let weatherData: Box<[HavaDurum.Hava]> = Box([])
//    let weeklyWeatherData: Box<HavaDurumWeekly?> = Box(nil)
//    let allCitiesWeatherData: Box<[HavaDurum]> = Box([])
//
//    let dispatchGroup = DispatchGroup()
//
//    override init() {
//        super.init()
//
//    }
//    func getWeather(city: String) {
//        let endPoint = Endpoint.daily(city: city)
//
//        APIManager.getJSON(url: endPoint.url) { (result: Result<HavaDurum, APIManager.APIError>) in
//            switch result {
//            case let .success(forecast):
//                let data = forecast.list[0]
//                self.temperature.value = data.main.degree
//                self.bigIcon.value = UIImage(named: data.weather[0].icon)
//                self.description.value = data.weather[0].descriptionTxt
//                self.visibility.value = data.visibilityTxt
//                self.wind.value = data.windTxt
//                self.humidity.value = data.main.humidityTxt
//                self.pressure.value = data.main.pressureTxt
//                self.date.value = data.dateTxtLong
//                self.weatherData.value = forecast.list
//            case let .failure(error):
//                switch error {
//                case let .error(errorString):
//                    print(errorString)
//                }
//            }
//        }
//        dispatchGroup.leave()
//    }
