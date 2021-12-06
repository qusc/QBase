//___FILEHEADER___

import Combine
import Foundation
import QBase

class ___FILEBASENAMEASIDENTIFIER___: ViewModel {
    let serviceContainer: ServiceContainer
    
    @Published var viewState: /*@START_MENU_TOKEN@*/View/*@END_MENU_TOKEN@*/.ViewState
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(serviceContainer: ServiceContainer) {
        self.serviceContainer = serviceContainer
        viewState = .init()
    }
    
    func trigger(_ input: /*@START_MENU_TOKEN@*/View/*@END_MENU_TOKEN@*/.Input) {
        switch input {

        }
    }
}
