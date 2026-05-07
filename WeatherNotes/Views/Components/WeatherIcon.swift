//
//  WeatherIcon.swift
//  WeatherNotes
//
import SwiftUI

// MARK: - WeatherIcon
enum WeatherIcon {

    static func symbol(for icon: String) -> String {
        let prefix = icon.prefix(2)
        let isNight = icon.hasSuffix("n")
        switch prefix {
        case "01": return isNight ? "moon.stars.fill"      : "sun.max.fill"
        case "02": return isNight ? "cloud.moon.fill"      : "cloud.sun.fill"
        case "03": return "cloud.fill"
        case "04": return "cloud.fill"
        case "09": return "cloud.drizzle.fill"
        case "10": return isNight ? "cloud.moon.rain.fill" : "cloud.sun.rain.fill"
        case "11": return "cloud.bolt.fill"
        case "13": return "snowflake"
        case "50": return "cloud.fog.fill"
        default:   return "cloud.fill"
        }
    }

    static func color(for icon: String) -> Color {
        let prefix = icon.prefix(2)
        switch prefix {
        case "01": return .orange
        case "02": return .blue
        case "03", "04": return .gray
        case "09", "10": return .blue
        case "11": return .purple
        case "13": return .cyan
        case "50": return .gray
        default:   return .blue
        }
    }
}
