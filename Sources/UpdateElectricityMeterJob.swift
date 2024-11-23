//
//  UpdateElectricityMeterJob.swift
//  home-control-adapter-goe-wallbox
//
//  Created by Christoph Pageler on 16.11.24.
//

import Foundation
import ShellyKit
import HomeControlKit
import HomeControlClient
import HomeControlLogging
import Logging

class UpdateElectricityMeterReadingsJob: Job {
    private let logger = Logger(homeControl: "adapter-shelly.update-electricitymeter-readings-job")
    private var homeControlClient: HomeControlClient
    private var meters: [ShellyDotEnv.Meter]

    init(
        homeControlClient: HomeControlClient,
        meters: [ShellyDotEnv.Meter]
    ) {
        self.homeControlClient = homeControlClient
        self.meters = meters

        super.init(maxAge: 2)
    }

    override func run() async {
        for meter in meters {
            do {
                try await runMeter(meter)
            } catch {
                logger.critical("Failed runMeter \(error)")
            }
        }
    }

    private func runMeter(_ meter: ShellyDotEnv.Meter) async throws {
        guard let shellyClient = ShellyClient(address: meter.shellyAddress) else {
            throw UpdateElectricityMeterJobError.failedToInitializeShellyClient
        }
        let date = Date()
        let status = try await shellyClient.status()
        guard let rawPower = status.apower else {
            throw UpdateElectricityMeterJobError.emptyPower
        }

        let factor: Double = meter.isInverted ? -1 : 1
        let power = rawPower * factor
        logger.info("Status for \(meter.shellyAddress) -> \(power)")

        let reading = ElectricityMeterReading(readingAt: date, power: power)
        let storedReading = try await homeControlClient.electricityMeter
            .readings(id: meter.electricityMeterID)
            .create(reading)

        logger.info("Stored reading \(storedReading.id)")
    }
}

enum UpdateElectricityMeterJobError: Error {
    case failedToInitializeShellyClient
    case emptyPower
}
