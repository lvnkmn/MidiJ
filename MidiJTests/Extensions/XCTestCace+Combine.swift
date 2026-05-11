//
//  XCTestCace+Combine.swift
//  MidiJTests
//
//  Created by me on 23/07/2023.
//

import Combine
import XCTest

extension XCTestCase {
    
    func assert<Value, Error, PublisherType: Publisher<Value, Error>>(
        thatPublisher publisher: PublisherType,
        receivesValues expectedValues: [Value],
        uponAction action: () -> () = {},
        usingAssertionClosure assertionClosure: (_ receivedValues: [Value], _ expectedValues: [Value]) -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let receivedValues = awaitReceivingOfValues(
            numbeOfValues: expectedValues.count,
            fromPublisher: publisher,
            afterAction: action
        )
        XCTAssert(
            assertionClosure(
                receivedValues,
                expectedValues
            ),
            file: file,
            line: line
        )
    }
    
    func assert<Value: Equatable, Error, PublisherType: Publisher<Value, Error>>(
        thatPublisher publisher: PublisherType,
        receivesValues expectedValues: [Value],
        uponAction action: () -> () = {},
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let receivedValues = awaitReceivingOfValues(
            numbeOfValues: expectedValues.count,
            fromPublisher: publisher,
            afterAction: action
        )
        XCTAssertEqual(receivedValues, expectedValues, file: file, line: line)
    }
    
    func awaitReceivingOfValues<Value, Error, PublisherType: Publisher<Value, Error>>(
        numbeOfValues: Int,
        fromPublisher publisher: PublisherType,
        afterAction action: () -> ()
    ) -> [Value] {
        let expectation = expectation(description: "awaiting values")
        var receivedValues = [Value]()
        let cancelable = publisher
            .sink { _ in
            } receiveValue: { value in
                receivedValues.append(value)
                if receivedValues.count == numbeOfValues {
                    expectation.fulfill()
                }
            }
        action()
        wait(for: [expectation], timeout: 0.2)
        cancelable.cancel()
        return receivedValues
    }
}
