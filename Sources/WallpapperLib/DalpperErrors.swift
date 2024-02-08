//
//  DalpperErrors.swift
//  Dalpper
//
//  Created by mito on 2024/2/6.
//

import Foundation

public enum DalpperErrors: Error {
    case imageLoadFailed(urlString: String)
    case imageURLInvalid(urlString: String)
    case dragFailed
}

extension DalpperErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageLoadFailed(let url):
            return NSLocalizedString("imageLoadFailed", comment: "") + ":\n" + url
        case .imageURLInvalid(let url):
            return NSLocalizedString("imageURLInvalid", comment: "") + ":\n" + url
        case .dragFailed:
            return NSLocalizedString("dragFailed", comment: "")
        }
    }
}
