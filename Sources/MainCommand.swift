//
//  MainCommand.swift
//  home-control-adapter-goe-wallbox
//
//  Created by Christoph Pageler on 31.10.24.
//

import ArgumentParser
import Foundation
import ShellyKit
import HomeControlClient
import HomeControlKit
import HomeControlLogging
import Logging

@main
struct MainCommand: AsyncParsableCommand {
    private static let logger = Logger(homeControl: "adapter-shelly.main-command")

    func run() async throws {
        LoggingSystem.bootstrapHomeControl()

        // Load environment from .env.json
        let dotEnv = try DotEnv<ShellyDotEnv>.fromWorkingDirectory()

        // Prepare home control client
        var homeControlClient = HomeControlClient.localhost
        homeControlClient.authToken = dotEnv.content.authToken

        // Prepare jobs
        let jobs: [Job] = [
            UpdateElectricityMeterReadingsJob(homeControlClient: homeControlClient, meters: dotEnv.content.meters)
        ]

        // run jobs until command is canceled using ctrl + c
        while true {
            for job in jobs {
                await job.runIfNeeded(at: Date())
            }
            await Task.sleep(1.seconds)
        }
    }
}
