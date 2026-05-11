//
//  +markdown.swift
//  MidiJ
//
//  Created by me on 14/08/2023.
//

import Foundation
import SourceSeeds
import UIKit

extension NSAttributedString {
    static func from(markDowntext: String) -> NSAttributedString {
        markDowntext
            .split(separator: "\n")
            .map(String.init)
            .map {
                NSAttributedString(string: $0.strippedMarkDownIdentifiers() + "\n", attributes: .forMarkdown(text: $0))
            }
            .reduce(NSMutableAttributedString(), { partialResult, line in
                partialResult.append(line)
                return partialResult
            })
    }
}


private extension String {
    func strippedMarkDownIdentifiers() -> String {
        MarkDown.LineClassifier.allCases
            .map(\.identifier)
            .reduce(self) { partialResult, identifier in
                partialResult.replacingOccurrences(of: identifier, with: "")
            }
    }
}

private enum MarkDown {
    
    enum LineClassifier: CaseIterable {
        case h5, h4, h3, h2, h1, paragraph
        
        var identifier: String {
            switch self {
            case .paragraph:
                return ""
            case .h1:
                return "# "
            case .h2:
                return "## "
            case .h3:
                return "### "
            case .h4:
                return "#### "
            case .h5:
                return "##### "
            }
        }
    }
}

typealias StringAttributes = [NSAttributedString.Key: Any]

extension StringAttributes {
    
    static func forMarkdown(text: String) -> StringAttributes {
        if text.starts(with: MarkDown.LineClassifier.h1.identifier) {
            return .h1
        } else if text.starts(with: MarkDown.LineClassifier.h2.identifier) {
            return .h2
        } else if text.starts(with: MarkDown.LineClassifier.h3.identifier) {
            return .h3
        } else if text.starts(with: MarkDown.LineClassifier.h4.identifier) {
            return .h4
        } else if text.starts(with: MarkDown.LineClassifier.h5.identifier) {
            return .h5
        } else {
            return .paragraph
        }
    }
    
    static var paragraph: StringAttributes {
        [
            .foregroundColor: UIColor.Constants.primaryTextColor,
            .font: UIFont.systemFont(ofSize: .Constants.fontSize13, weight: .light),
            .paragraphStyle: NSMutableParagraphStyle().mutated { it in
                it.lineSpacing = 4
                it.paragraphSpacing = 8
            }
        ]
    }
    
    static var h1: StringAttributes {
        [
            .foregroundColor: UIColor.Constants.primaryTextColor,
            .font: UIFont.systemFont(ofSize: .Constants.fontSize48, weight: .regular),
            .paragraphStyle: NSMutableParagraphStyle().mutated { it in
                it.paragraphSpacing = 10
            }
        ]
    }
    
    static var h2: StringAttributes {
        [
            .foregroundColor: UIColor.Constants.primaryTextColor,
            .font: UIFont.systemFont(ofSize: .Constants.fontSize20, weight: .regular),
            .paragraphStyle: NSMutableParagraphStyle().mutated { it in
                it.paragraphSpacing = 10
            }
        ]
    }
    
    static var h3: StringAttributes {
        [
            .foregroundColor: UIColor.Constants.primaryTextColor,
            .font: UIFont.systemFont(ofSize: .Constants.fontSize15, weight: .bold),
            .paragraphStyle: NSMutableParagraphStyle().mutated { it in
                it.paragraphSpacing = 10
            }
        ]
    }
    
    static var h4: StringAttributes {
        [
            .foregroundColor: UIColor.Constants.primaryTextColor,
            .font: UIFont.systemFont(ofSize: .Constants.fontSize15, weight: .regular),
            .paragraphStyle: NSMutableParagraphStyle().mutated { it in
                it.paragraphSpacing = 10
            }
        ]
    }
    
    static var h5: StringAttributes {
        [
            .foregroundColor: UIColor.Constants.primaryTextColor,
            .font: UIFont.systemFont(ofSize: .Constants.fontSize14, weight: .regular),
            .paragraphStyle: NSMutableParagraphStyle().mutated { it in
                it.paragraphSpacing = 10
            }
        ]
    }
}

extension AttributeContainer: Mutatable {
    
    static var heading: AttributeContainer {
        .init()
        .mutated { it in
            it.foregroundColor = .red
        }
    }
}
