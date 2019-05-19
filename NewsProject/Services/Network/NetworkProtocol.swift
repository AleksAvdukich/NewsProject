//
//  NetworkProtocol.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var urlRequest: URLRequest? { get }
}

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}

protocol RequestSenderProtocol {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
