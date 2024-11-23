//
//  ShellyDotEnv.swift
//  home-control-adapter-shelly
//
//  Created by Christoph Pageler on 22.11.24.
//

import Foundation

struct ShellyDotEnv: Codable {
    let authToken: String
    let meters: [Meter]

    enum CodingKeys: String, CodingKey {
        case authToken = "AUTH_TOKEN"
        case meters = "METERS"
    }

    struct Meter: Codable {
        let shellyAddress: String
        let electricityMeterID: UUID
        let isInverted: Bool

        enum CodingKeys: String, CodingKey {
            case shellyAddress = "SHELLY_ADDRESS"
            case electricityMeterID = "ELECTRICITY_METER_ID"
            case isInverted = "IS_INVERTED"
        }
    }
}
