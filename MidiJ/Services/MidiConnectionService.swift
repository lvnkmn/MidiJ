//
//  MidiConnectionService.swift
//  MidiJ
//
//  Created by me on 02/03/2022.
//

import Foundation

#warning("Todo: Test that this all still works")
class MidiConnectionService {
    
    static let shared: MidiConnectionService = {
#if targetEnvironment(simulator)
        MidiConnectionService()
#else
        MidiConnectionService.Production()
#endif
    }()
    
    private init() {}
    
    var isConnected: Bool { false }
    
    var connectedDestinations: [String] { [] }
    
    var timelinePosition: Double { 0 }
    
    func connectToAllDestinations() {}
    
    func disconnectFromAllDestinations() {}
    
    func set(tempo: Double) {}
    
    func startClock() {}
    
    func stopClock() {}
}

#if !targetEnvironment(simulator)
private extension MidiConnectionService {
    
    class Production: MidiConnectionService {
        
        private let midiClockSenderInterface: SEMIDIClockSenderCoreMIDIInterface
        private let midiClockSender: SEMIDIClockSender
        
        fileprivate override init() {
            midiClockSenderInterface = .init()
            midiClockSender = .init(interface: midiClockSenderInterface)
            midiClockSender.sendClockTicksWhileTimelineStopped = false
            
            super.init()
            
            notifyAboutChangedConnections()
        }
        
        private var obserVation: NSKeyValueObservation?
        
        override var isConnected: Bool {
            midiClockSenderInterface.destinations.count > 0
        }
        
        override var connectedDestinations: [String] {
            midiClockSenderInterface.destinations
                .compactMap {
                    $0 as? SEMIDIEndpoint
                }
                .map(\.name)
        }
        
        override var timelinePosition: Double {
            midiClockSender.timelinePosition
        }
        
        private func notifyAboutChangedConnections() {
            obserVation = midiClockSenderInterface.observe(
                \SEMIDIClockSenderCoreMIDIInterface.availableDestinations,
                 options: .new,
                 changeHandler: { midiSender, change in
                     NotificationCenter.default.post(name: .midiDestinationsDidChange, object: nil)
                 })
        }
        
        override  func connectToAllDestinations() {
            midiClockSenderInterface.destinations = midiClockSenderInterface.availableDestinations
        }
        
        override func disconnectFromAllDestinations() {
            midiClockSenderInterface.destinations = []
        }
        
        override func set(tempo: Double) {
            midiClockSender.tempo = tempo
        }
        
        override func startClock() {
            midiClockSender.start(atTime: 0)
        }
        
        override func stopClock() {
            midiClockSender.stop()
        }
    }
}
#endif
