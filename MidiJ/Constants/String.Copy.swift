//
//  String.Copy.swift
//  MidiJ
//
//  Created by me on 06/03/2023.
//

import Foundation

extension String {
    enum Copy {
        enum ButtonTitle {
            static let cue = "Cue"
            static let play = "Play"
        }
        
        enum ConnectionType {
            static let midi = "MIDI"
        }
        
        static let connectingExplaination = """
                                Connect to your
                                MIDI device using required plugs
                                (see MidiJ 101 in Menu)
                                to switch to connected state.
                                Make sure your MIDI device is 
                                set to MIDI clock receive mode.
                                """
        
        enum Documentation {
            static let title = "MidiJ 101"
            static let intro =
            """
            MidiJ allows DJing with all MIDI hardware that listens to MIDI clock signals. In laymen's terms it allows starting, stopping, pitching and cueing of MIDI hardware as a dj would expect it to work.
            """
            static let connectingExplaination =
"""
### Connecting to MIDI hardware

For hardware to work you will need the following to cables & plugs.

#### For iOS Devices with USB-C connector

##### To connect to MIDI DIN (5-pin round plug) music hardware
The following cables / adapters are needed:
* USB-C to USB-A adapter
* USB-A to MIDI DIN cable
Connect as following:
iOS device → USB-C to USB-A adapter → USB-A to MIDI DIN cable → music hardware

##### To connect to USB-B music hardware
The following cables / adapters are needed:
* USB-C to USB-A adapter
* USB-A to USB-B cable (also known as printer cable)
Connect as following:
iOS device → USB-C to USB-A adapter → USB-A to USB-B cable → music hardware

##### To connect to USB-C music hardware
The following cables / adapters are needed:
* USB-C cable
Connect as following:
iOS device → USB-C cable → music hardware

#### For iOS Devices with lightning connector

##### To connect to MIDI DIN (5-pin round plug) music hardware
The following cables / adapters are needed:
* Apple Lightning to USB Camera Adapter (also called Camera Connection Kit)
* USB-A to MIDI DIN cable
Connect as following:
iOS device → Apple Lightning to USB Camera Adapter → USB-A to MIDI DIN cable → music hardware

##### To connect to USB-B music hardware
The following cables / adapters are needed:
* Apple Lightning to USB Camera Adapter (also called Camera Connection Kit)
* USB-A to USB-B cable (also known as printer cable)
Connect as following:
iOS device → Apple Lightning to USB Camera Adapter → USB-A to USB-B cable → music hardware

##### To connect to USB-C music hardware
The following cables / adapters are needed:
* Apple Lightning to USB Camera Adapter (also called Camera Connection Kit)
* USB-A to USB-C cable
Connect as following:
iOS device → Apple Lightning to USB Camera Adapter → USB-A to USB-C cable → music hardware

#### Indicator
Once you connect the USB → MIDI cable to your i device using the Lighting to USB cable/plug, the indicator of the connect button should turn green in less then a second, you don’t have to be in the connect menu for this.
You can now use MidiJ with you MIDI hardware, make sure though that the hardware you’re using is configured to accept incoming MIDI (clock) information.

### Connecting to other apps on the same device

Any MIDI enabled app will appear as a connection. If they have ben setup to accept incoming MIDI (clock) information, they should work with MidiJ out of the box. If not, configure them to do so.
"""
            
            static let bpmTapButtonExplanation = """
            ### BPM tap button
            Located below the settings and connect button.
            Displays the actual BPM that is either sent to MIDI.
            The actual BPM is the result of the base BPM multiplied by the temporary and permanent tempo adjustments done by the ypad and tempo slider.
            Allows setting the base BPM in two ways:
            * By tapping rhythmically along with the tempo of another sound source.
            The average time between each tap will be used to calculate the base bpm.
            * By either long pressing or two finger tapping, a base BPM can be entered manually.
            """
            
            static let cueButtonExplanation = """
            ### Cue button
            Located below the tap button.
            Allows “cueing” or counting in of the source controlled by either MIDI or Ableton link.
            While the cue button is held, the controlled source plays, when the cue button is lifted the source will stop playing immediately unless the play button was pressed in the mean time. If the play button was pressed while pressing the cure button, the source will continue playing.
            """
            
            static let playStopButtonExplanation = """
            ### Play/Stop button
            Located below the cue button.
            Allows immediate play or stop of the controlled source.
            Allows continuation of playback when cue button is being held.
            """
            
            static let yPad =
                        """
                        ### Ypad
                        Located below the nudge value button.
                        Allows temporary manipulating the bpm.
                        Pressing and holding either the upper or lower part of the ypad makes the tempo go up or down 5 percent during the time it’s held. The + and - markers indicate if the upper or lower part will make the BPM go up or down.
                        """
            static let nudgeValueButton =
            """
            ### Nudge value button
            Located in the bottom left of the screen.
            Shows the percentage of temporarily added or subtracted speed from the base BPM that is changed by the ypad.
            When pressed a menu is shown which allows for changing of nudge related settings.
            """
            
            static let tempoValueButtton =
            """
            ### Tempo value button
            Located to the bottom right of the screen.
            Shows the percentage of permanently added or subtracted speed from the base BPM that is changed by the Tempo slider.
            When pressed a menu is shown which allows for changing of nudge related settings.
            """
            
            static let menuButton =
            """
            ### Menu button
            Located in the top left of the screen.
            When pressed a menu is shown which allows changing of various global settings.
            """
            
            static let connectionButton =
            """
            ### Connection button
            Located to the right of the screen.
            Shows when connected to (green) or disconnected from (orange) to MIDI device cable. When the MIDI cable is plugged into a MIDI device, and settings it's clock mode to receive MIDI, it should start being controllable by MidiJ.
            """
            
            static let tempoFader =
            """
            ### Tempo fader
            Located below the tempo value button.
            Allows permanently changing the actual tempo based on the base BPM in two ways.
            By sliding the slider up or down. By default up, will make the tempo go down as indictated by the *+* and *-* markers. This setting can be changed as desired in the menu that appears by pressing the tempo value button.
            By sliding up or down on the whole region of where the fader can slide, but outside of the fader itself. This will cause finetuning of the faders position and therefore the tempo.
            """
        }
        
        enum Acknowledgements {
            enum Libraries {
                static let intro = """
                ## Credits
                ### Design
                * Maarten de Winter
                * Rick Schot
                * Menno Lovink
                
                ### Concept & Coding
                * Menno Lovink
                
                ### Feedback and testing
                * (Nachtvorst) Dirk & Bram
                * (Cosmic force) Ben
                
                ### Open source libraries
                This app leverages code from the open source libraries listed below. If any of theres are from you, thanks!
                """
                
                static let pgMidi = """
                #### PGMidi
                Feel free to incorporate this code in your own applications.

                I'd appreciate hearing from you if you do so. It's nice to know that I've been helpful. Attribution is welcomed, but not required.

                Copyright (c) 2010-2015 Pete Goodliffe. All rights reserved.
                """
                
                static let theSpectacularSyncEngine = """
                #### The Spectacular Sync Engine
                License

                Copyright (C) 2015 A Tasty Pixel

                This software is provided 'as-is', without any express or implied
                warranty.  In no event will the authors be held liable for any damages
                arising from the use of this software.

                Permission is granted to anyone to use this software for any purpose,
                including commercial applications, and to alter it and redistribute it
                freely, subject to the following restrictions:

                1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
                2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
                3. This notice may not be removed or altered from any source distribution.
                """
                
                static let swiftHUEColorPicker = """
                #### SwiftHUEColorPicker
                The MIT License (MIT)

                Copyright (c) 2015 Maxim Bilan

                Permission is hereby granted, free of charge, to any person obtaining a copy
                of this software and associated documentation files (the "Software"), to deal
                in the Software without restriction, including without limitation the rights
                to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                copies of the Software, and to permit persons to whom the Software is
                furnished to do so, subject to the following conditions:

                The above copyright notice and this permission notice shall be included in all
                copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                SOFTWARE.
                """
                
                static var all: String {
                    [
                        .Copy.Acknowledgements.Libraries.intro,
                        .Copy.Acknowledgements.Libraries.pgMidi,
                        .Copy.Acknowledgements.Libraries.theSpectacularSyncEngine,
                        .Copy.Acknowledgements.Libraries.swiftHUEColorPicker
                    ].joined(separator: "\n")
                }
            }
        }
    }
}
