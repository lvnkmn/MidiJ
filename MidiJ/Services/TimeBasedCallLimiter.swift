//
//  TimeBasedCallLimiter.swift
//  MidiJ
//
//  Created by Menno Lovink on 30/01/2023.
//

import Foundation

class TimeBasedCallLimiter {
    let minimumTimeBetweenCalls: TimeInterval
    let call: ()->()

    private var momentOfLastCall: Date? = nil

    public init(minimumTimeBetweenCalls: TimeInterval, call: @escaping () -> ()) {
        self.minimumTimeBetweenCalls = minimumTimeBetweenCalls
        self.call = call
    }

    func callWhenAllowed() {
        if let momentOfLastCall {
            if Date().timeIntervalSince(momentOfLastCall) > minimumTimeBetweenCalls {
                performCall()
            }
        } else {
            performCall()
        }
    }

}

private extension TimeBasedCallLimiter {

    func performCall() {
        momentOfLastCall = .init()
        call()
    }
}
