//
//  Array+compactMap.swift
//  VoiceBeam
//
//  Created by Quirin Schweigert on 07.12.21.
//

import Foundation

extension Array {
    func compactMap<T>() -> [T] where Element == T? {
        compactMap { $0 }
    }
}
