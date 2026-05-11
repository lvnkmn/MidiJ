//
//  AnyPublisher+typeInferedJust.swift
//  MidiJ
//
//  Created by me on 18/05/2023.
//

import Combine

extension AnyPublisher where Failure == Never {
    
    static func just(value: Output) -> AnyPublisher<Output, Failure> {
        Just(value).eraseToAnyPublisher()
    }
}
