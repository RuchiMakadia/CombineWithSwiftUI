//
//  WebRequest.swift
//  combineSwifUIDemo
//
//  Created by eHeuristic on 11/12/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import Foundation
import Combine

func web_request<T>(with url: URL) -> AnyPublisher<[T],enum_error_type> where T: Decodable {
    let requst = URLRequest(url: url)
    return URLSession.shared.dataTaskPublisher(for: requst)
    .mapError { error in
            enum_error_type.network(description: error.localizedDescription)
    }
    .flatMap(maxPublishers: .max(1)) { pair in
        decode(pair.data)
    }
    .eraseToAnyPublisher()
}

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<[T], enum_error_type> {
    let decoder = JSONDecoder()
    return Just(data)
        .decode(type: [T].self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
