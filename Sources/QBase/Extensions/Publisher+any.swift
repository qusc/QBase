//
//  Publisher+any.swift
//  VoiceBeam
//
//  Created by Quirin Schweigert on 01.12.21.
//

import Combine
import Foundation

public extension Publisher {
    func any() -> AnyPublisher<Output, Failure> {
        eraseToAnyPublisher()
    }
}
