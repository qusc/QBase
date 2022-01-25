import Foundation
import FirebaseAuth
import Combine

public class AuthenticationService {
    struct Constants {
        static let verificationIDUserDefaultsKey =
            "QBase.UserDatabaseService.verificationID"
    }

    public enum State: Equatable, Sendable {
        case waitingForPhoneNumber
        case requestingVerificationCode
        case waitingForVerificationCode(verificationID: String)
        case checkingVerificationCode
        case authenticated(userID: String)
    }

    @Published public var state: State
    @Published public var errorMessage: String?

    public init() {
        if let userID = Auth.auth().currentUser?.uid {
            // user is already signed into firebase auth
            self.state = .authenticated(userID: userID)
        } else {
            if let savedVerificationID = UserDefaults.standard
                .string(forKey: Constants.verificationIDUserDefaultsKey) {

                // try to continue verification / sign up process by recovering verifiationID
                state = .waitingForVerificationCode(verificationID: savedVerificationID)
            } else {
                // verification process has to start from the beginning
                state = .waitingForPhoneNumber
            }
        }
    }

    public func verifyPhoneNumber(phoneNumber: String) {
        errorMessage = nil
        state = .requestingVerificationCode
        UserDefaults.standard.removeObject(forKey: Constants.verificationIDUserDefaultsKey)

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                if (error as NSError).code == FirebaseAuth.AuthErrorCode.invalidPhoneNumber.rawValue {
                    self.errorMessage =
                        "Please enter a valid phone number including your country code, e.g. +1 (555) 555-1234."
                } else {
                    self.errorMessage = error.localizedDescription
                }

                print("firebase phone auth error: \(error.localizedDescription)")
                self.state = .waitingForPhoneNumber
                return
            }

            if let verificationID = verificationID {
                print("firebase phone auth verificationID: \(verificationID)")

                // persist verificationID to allow the verification process to continue if the app
                // is killed while the user is e.g. checking her incoming SMS
                UserDefaults.standard.set(
                    verificationID,
                    forKey: Constants.verificationIDUserDefaultsKey
                )

                self.state = .waitingForVerificationCode(verificationID: verificationID)
            }
        }
    }

    public func supplyVerificationCode(verificationCode: String) {
        guard case .waitingForVerificationCode(let verificationID) = state else { return}

        errorMessage = nil
        state = .checkingVerificationCode

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("firebase sign in error: \(error)")
                self.errorMessage = "Provided code couldn't be verified"
                self.state = .waitingForPhoneNumber
                return
            }

            if let userID = authResult?.user.uid {
                self.state = .authenticated(userID: userID)
            } else {
                self.errorMessage = "Error signing in."
                self.state = .waitingForPhoneNumber
            }

            UserDefaults.standard.removeObject(forKey: Constants.verificationIDUserDefaultsKey)
        }
    }

    public func signOut() {
        try? Auth.auth().signOut()
        state = .waitingForPhoneNumber
    }
}

public extension AuthenticationService.State {
    var userID: String? {
        if case .authenticated(let userID) = self { return userID }
        return nil
    }
}
