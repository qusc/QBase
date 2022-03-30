import Foundation
import Combine
import FirebaseFirestore

public extension DocumentReference {
    struct Publisher: Combine.Publisher {
        public typealias Output = [String: Any]
        public typealias Failure = Error

        let documentReference: DocumentReference

        public func receive<S>(subscriber: S)
        where S : Subscriber, Failure == S.Failure, Output == S.Input {
            subscriber.receive(
                subscription: Subscription<S>(
                    documentReference: documentReference,
                    target: subscriber
                )
            )
        }
    }

    class Subscription<Target: Subscriber>: Combine.Subscription
    where Target.Input == Publisher.Output, Target.Failure == Publisher.Failure {
        let listenerRegistration: ListenerRegistration

        public func request(_ demand: Subscribers.Demand) { }

        public func cancel() {
            listenerRegistration.remove()
        }

        public init(documentReference: DocumentReference, target: Target) {
            listenerRegistration = documentReference.addSnapshotListener { (snapshot, error) in
                if let snapshot = snapshot, let data = snapshot.data() {
                    _ = target.receive(data)
                } else {
                    _ = target.receive([:])
                }

                if let error = error {
                    target.receive(completion: .failure(error))
                }
            }
        }
    }

    func publisher() -> Publisher {
        Publisher(documentReference: self)
    }
}
