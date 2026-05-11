//
//  UIViewRepresenter.swift
//  MidiJ
//
//  Created by me on 16/01/2023.
//

import UIKit
import SwiftUI

struct UIViewRepresenter<T: UIView>: UIViewRepresentable {
    let makeRepresentedView: ()->(T)
    
    func makeUIView(context: Context) -> T {
        makeRepresentedView()
    }
    
    func updateUIView(_ uiView: T, context: Context) {}
}
