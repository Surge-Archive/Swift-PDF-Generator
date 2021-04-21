//
//  File.swift
//  
//
//  Created by Marwan Elwaraki on 21/04/2021.
//

import Foundation

// Join attributed strings with a seperator:
// https://stackoverflow.com/questions/32830519/is-there-joinwithseparator-for-attributed-strings/32830756
extension Sequence where Iterator.Element == NSAttributedString {
    
    /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
    /// - parameters:
    ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
    func joined(with separator: NSAttributedString) -> NSAttributedString {
        return self.reduce(NSMutableAttributedString()) {
            (result, attributedString) in
            if result.length > 0 {
                result.append(separator)
            }
            result.append(attributedString)
            return result
        }
    }
    
    /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
    /// - parameters:
    ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
    func joined(with separator: String = "") -> NSAttributedString {
        return self.joined(with: NSAttributedString(string: separator))
    }
}
