//
//  Subject.swift
//  Turnstile
//
//  Created by Edward Jiang on 7/26/16.
//
//

class Subject {
    weak var turnstile: Turnstile!
    
    init(turnstile: Turnstile) {
        self.turnstile = turnstile
    }
    
    func login(credentials: Credentials) throws {
        if credentials.verify() {
            print("success!")
        } else {
            throw IncorrectCredentialsError()
        }
    }
}

protocol Credentials {
    func verify() -> Bool
}

struct UsernamePasswordCredentials: Credentials {
    let username: String
    let password: String
    
    func verify() -> Bool {
        return password == "TestTest1"
    }
}

struct IncorrectCredentialsError: ErrorProtocol {}
