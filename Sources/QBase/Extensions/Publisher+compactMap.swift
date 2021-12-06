//
//  Publisher+compactMap.swift
//  VoiceBeam
//
//  Created by Quirin Schweigert on 06.12.21.
//

import Foundation
import Combine

public extension Publisher {
    func compactMap<T>() -> Publishers.CompactMap<Self, T> where Output == T? {
        compactMap { $0 }
    }
}
