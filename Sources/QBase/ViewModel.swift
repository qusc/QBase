// Based on https://github.com/quickbirdstudios/SwiftUI-Architectures/blob/master/QBChat-MVVM/QBChat-MVVM/MVVM/ViewModel.swift
//
// Original license:

// MIT License
//
// Copyright (c) 2019 QuickBird Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Combine

public protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype ViewState
    associatedtype Input

    var viewState: ViewState { get }
    func trigger(_ input: Input)
}

extension AnyViewModel: Identifiable where State: Identifiable {
    public var id: State.ID {
        viewState.id
    }
}

@dynamicMemberLookup
public final class AnyViewModel<State, Input>: ViewModel {
    private let getObjectWillChange: () -> AnyPublisher<Void, Never>
    private let getState: () -> State
    private let getTrigger: (Input) -> Void

    public var objectWillChange: AnyPublisher<Void, Never> {
        getObjectWillChange()
    }

    public var viewState: State {
        getState()
    }

    public func trigger(_ input: Input) {
        getTrigger(input)
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        viewState[keyPath: keyPath]
    }

    public init<V: ViewModel>(_ viewModel: V) where V.ViewState == State, V.Input == Input {
        self.getObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
        self.getState = { viewModel.viewState }
        self.getTrigger = viewModel.trigger
    }
}
