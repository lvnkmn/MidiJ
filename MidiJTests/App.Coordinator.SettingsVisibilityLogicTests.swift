//
//  MidiJTests.swift
//  MidiJTests
//
//  Created by User on 21/01/2022.
//

import XCTest
import Combine
@testable import MidiJ

@available(iOS 16.0.0, *)
class AppCoordinatorSettingsVisibilityLogicTests: XCTestCase {
    private var cancelables = Set<AnyCancellable>()
    
    func testSettingsViewControllerIsStartingToBeDisplayedUponFirstTapOfMenuButton() throws {
        let sut = arrange()
        assert(
            thatPublisher: sut.sut.startDisplayingSettingsViewController,
            receivesValues: [()],
            uponAction: {
                sut.onMenuButtonTap.send()
            }, usingAssertionClosure: { receivedValues, expectedValues in
                receivedValues.count == expectedValues.count
            }
        )
    }
    
    func testSettingsViewControllerIsStartingToBeDisplayedUponFirstTapOfMenuButtonAndIsntDisplayedAgainAfterFistTap() throws {
        let sut = arrange()
        assert(
            thatPublisher: sut.sut.startDisplayingSettingsViewController,
            receivesValues: [()],
            uponAction: {
                sut.onMenuButtonTap.send()
                sut.onMenuButtonTap.send()
            }, usingAssertionClosure: { receivedValues, expectedValues in
                receivedValues.count == expectedValues.count
            }
        )
    }
}

@available(iOS 16.0.0, *)
private extension AppCoordinatorSettingsVisibilityLogicTests {
    
    func arrange() -> (
        sut: App.Coordinator.SettingsVisibilityLogic,
        onMenuButtonTap: any Subject<Void, Never>,
        onDidShowViewController: any Subject<UIViewController, Never>
    ) {
        let onMenuButtonTap = PassthroughSubject<Void, Never>()
        let onDidShowViewController = PassthroughSubject<UIViewController, Never>()
        let sut = App.Coordinator.SettingsVisibilityLogic(
            onMenuButtonTap: onMenuButtonTap,
            onDidShowViewController: onDidShowViewController
        )
        
        return (sut, onMenuButtonTap, onDidShowViewController)
    }
}
