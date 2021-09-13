import Foundation
import Combine
import FirebaseFirestore

public extension Query {
    struct Publisher: Combine.Publisher {
        public typealias Output = [QueryDocumentSnapshot]
        public typealias Failure = Error

        let query: Query

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            subscriber.receive(subscription: Subscription<S>(query: query, target: subscriber))
        }
    }

    class Subscription<Target: Subscriber>: Combine.Subscription
    where Target.Input == Publisher.Output, Target.Failure == Publisher.Failure {
        let listenerRegistration: ListenerRegistration

        public func request(_ demand: Subscribers.Demand) { }

        public func cancel() {
            listenerRegistration.remove()
        }

        public init(query: Query, target: Target) {
            listenerRegistration = query.addSnapshotListener { (snapshot, error) in
                if let snapshot = snapshot {
                    _ = target.receive(snapshot.documents)
                }

                if let error = error {
                    target.receive(completion: .failure(error))
                }
            }
        }
    }

    func publisher() -> Publisher {
        Publisher(query: self)
    }
}
