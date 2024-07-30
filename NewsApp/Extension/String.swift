//
//  String.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import Foundation
import UIKit

extension String {
    /// Configures links in the format of [Text](Link)
    func parseLinks() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
            
        // Regular expression to find markdown-style links
        let regex = try! NSRegularExpression(pattern: "\\[(.*?)\\]\\((.*?)\\)", options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
        for match in matches.reversed() {
            let linkTextRange = match.range(at: 1)
            let linkURLRange = match.range(at: 2)
                
            if let linkTextRange = Range(linkTextRange, in: self),
               let linkURLRange = Range(linkURLRange, in: self)
            {
                let linkText = String(self[linkTextRange])
                let linkURL = String(self[linkURLRange])
                    
                // Replace the full markdown link with just the link text
                attributedString.replaceCharacters(in: match.range, with: linkText)
                    
                // Apply the link attribute
                let linkRange = NSRange(location: match.range.location, length: linkText.count)
                attributedString.addAttribute(.link, value: linkURL, range: linkRange)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)
            }
        }
        
        return attributedString
    }
}
