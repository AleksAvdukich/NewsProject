//
//  RequestConfig.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

// Конфиг.
struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}
