//
//  URL+makeForEndpoint.swift
//  CryptoRatesAF
//
//  Created by Владимир Беляев on 17.01.2021.
//

import Foundation

extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.coingecko.com/api/v3/\(endpoint)")!
    }
}
