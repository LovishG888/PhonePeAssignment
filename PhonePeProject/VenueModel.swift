//
//  VenueModel.swift
//  PhonePeProject
//
//  Created by LOVISH on 25/11/23.
//

import Foundation

import Foundation

struct Venue: Codable {
    let state: String?
    let nameV2: String?
    let postalCode: String?
    let name: String?
    let links: [String]?
    let timezone: String?
    let url: String?
    let score: Int?
    let location: Location?
    let address: String?
    let country: String?
    let hasUpcomingEvents: Bool?
    let numUpcomingEvents: Int?
    let city: String?
    let slug: String?
    let extendedAddress: String?
    let stats: Stats?
    let id: Int?
    let popularity: Int?
    let accessMethod: String?
    let metroCode: Int?
    let capacity: Int?
    let displayLocation: String?

    enum CodingKeys: String, CodingKey {
        case state
        case nameV2 = "name_v2"
        case postalCode = "postal_code"
        case name, links, timezone, url, score, location, address, country
        case hasUpcomingEvents = "has_upcoming_events"
        case numUpcomingEvents = "num_upcoming_events"
        case city, slug
        case extendedAddress = "extended_address"
        case stats, id, popularity
        case accessMethod = "access_method"
        case metroCode = "metro_code"
        case capacity
        case displayLocation = "display_location"
    }
}

struct Location: Codable {
    let lat, lon: Double?
}

struct Stats: Codable {
    let eventCount: Int?

    enum CodingKeys: String, CodingKey {
        case eventCount = "event_count"
    }
}

struct VenuesResponse: Codable {
    let venues: [Venue]
    let meta: Meta?
}

struct Meta: Codable {
    let total, took, page, perPage: Int?
    let geolocation: Geolocation?
}

struct Geolocation: Codable {
    let lat, lon: Double?
    let city, state, country, postalCode: String?
    let displayName: String?
    let metroCode: String?
    let range: String?
}

