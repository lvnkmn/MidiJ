//
//  UITextField+DoneCancelToolbar.swift
//

import UIKit

class DecimalPadToolbar: UIToolbar {
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        doneButton.tintColor = .Constants.primaryTextColor
        cancelButton.tintColor = .Constants.primaryTextColor
        
        items = [
            cancelButton,
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButton
        ]
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
