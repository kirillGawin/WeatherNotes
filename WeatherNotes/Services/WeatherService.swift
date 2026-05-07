//
//  WeatherService.swift
//  WeatherNotes
//
import Foundation

// MARK: - WeatherError

enum WeatherError: LocalizedError {
    case invalidURL
    case noNetwork
    case badServerResponse(statusCode: Int)
    case decodingFailed(underlying: Error)
    case unknown(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .noNetwork:
            return "No internet connection. Please check your network."
        case .badServerResponse(let code):
            return "Server error (code \(code)). Please try again later."
        case .decodingFailed:
            return "Failed to parse server response."
        case .unknown(let err):
            return err.localizedDescription
        }
    }
}

// MARK: - WeatherServiceProtocol

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherSnapshot
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherSnapshot
}

// MARK: - WeatherService

final class WeatherService: WeatherServiceProtocol {

    private let apiKey  = "your_api_key"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    init() { }

    // MARK: - Fetch by city

    func fetchWeather(for city: String) async throws -> WeatherSnapshot {
        let params: [URLQueryItem] = [
            .init(name: "q",     value: city),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric"),
            .init(name: "lang",  value: "en"),
        ]
        return try await request(params: params)
    }

    // MARK: - Fetch by coordinates

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherSnapshot {
        let params: [URLQueryItem] = [
            .init(name: "lat",   value: String(lat)),
            .init(name: "lon",   value: String(lon)),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric"),
            .init(name: "lang",  value: "en"),
        ]
        return try await request(params: params)
    }

    // MARK: - Core request

    private func request(params: [URLQueryItem]) async throws -> WeatherSnapshot {
        guard var components = URLComponents(string: baseURL) else {
            throw WeatherError.invalidURL
        }
        components.queryItems = params

        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .cannotFindHost,
                 .cannotConnectToHost,
                 .timedOut:
                throw WeatherError.noNetwork
            default:
                throw WeatherError.unknown(underlying: urlError)
            }
        } catch {
            throw WeatherError.unknown(underlying: error)
        }

        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw WeatherError.badServerResponse(statusCode: http.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return WeatherSnapshot.from(decoded)
        } catch {
            throw WeatherError.decodingFailed(underlying: error)
        }
    }
}
