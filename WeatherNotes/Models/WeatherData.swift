//
//  WeatherData.swift
//  WeatherNotes
//


import Foundation
 
// MARK: - OpenWeather API Response
struct WeatherResponse: Codable {
    let weather: [WeatherCondition]
    let main:    MainWeather
    let name:    String            
}
 
struct WeatherCondition: Codable {
    let id:          Int
    let main:        String
    let description: String
    let icon:        String
}
 
struct MainWeather: Codable {
    let temp:       Double
    let feelsLike:  Double
    let humidity:   Int
 
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
    }
}
 
// MARK: - WeatherSnapshot
struct WeatherSnapshot {
    let temperature:  Double
    let feelsLike:    Double
    let humidity:     Int
    let description:  String
    let icon:         String
    let locationName: String

    var temperatureFormatted: String {
        String(format: "%.0f°C", temperature)
    }
 
    var feelsLikeFormatted: String {
        String(format: "%.0f°C", feelsLike)
    }
 
    static func from(_ response: WeatherResponse) -> WeatherSnapshot {
        let condition = response.weather.first
        return WeatherSnapshot(
            temperature:  response.main.temp,
            feelsLike:    response.main.feelsLike,
            humidity:     response.main.humidity,
            description:  condition?.description ?? "—",
            icon:         condition?.icon ?? "01d",
            locationName: response.name
        )
    }
 
    static func from(_ entity: NoteEntity) -> WeatherSnapshot {
        WeatherSnapshot(
            temperature:  entity.temperature,
            feelsLike:    entity.feelsLike,
            humidity:     Int(entity.humidity),
            description:  entity.weatherDescription ?? "—",
            icon:         entity.weatherIcon ?? "01d",
            locationName: entity.locationName ?? "—"
        )
    }
}
