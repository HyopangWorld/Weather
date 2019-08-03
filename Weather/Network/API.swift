//
//  API.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation


// MARK: - HTTPMethod
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public typealias Parameters = [String: Any]?
public typealias Headers = [String: String]?


