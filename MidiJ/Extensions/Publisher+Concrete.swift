//
//  Publisher+Concrete.swift
//  MidiJ
//
//  Created by me on 20/07/2023.
//

import Combine

extension Publisher {
    typealias Concrete = AnyPublisher<Output, Failure>
}
