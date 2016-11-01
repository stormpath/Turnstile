# Turnstile
[![Build Status](https://api.travis-ci.org/stormpath/Turnstile.svg?branch=master)](https://travis-ci.org/stormpath/Turnstile)
[![codecov](https://codecov.io/gh/stormpath/Turnstile/branch/master/graph/badge.svg)](https://codecov.io/gh/stormpath/Turnstile)
[![codebeat badge](https://codebeat.co/badges/ba981396-2a2c-4364-8067-6c128758f3bc)](https://codebeat.co/projects/github-com-stormpath-turnstile)
[![Slack Status](https://talkstormpath.shipit.xyz/badge.svg)](https://talkstormpath.shipit.xyz)

Turnstile is a security framework for Swift inspired by [Apache Shiro](http://shiro.apache.org). It's used to manage the currently executing user account in your application, whether iOS app or backend web application. 

# Overview

Turnstile is the easiest way to add authentication to your Swift apps. Currently, the focus is on a great API for backend Swift apps. 

Turnstile is split into three projects:

* Turnstile Core - provides key components for authentication and security. 
* Turnstile Crypto - tools for generating randomness, hashing, and encrypting data
* Turnstile Web - integrations with Facebook, Google, and other helpers useful for backend web applications. 

If you're a developer of an application or product and need to integrate Turnstile, read the docs for Turnstile Core. Otherwise, if you're a developer using a Turnstile integration, read the docs for Turnstile Web.

# Getting Started

The easiest way to use Turnstile is with one of its prebuilt integrations with Swift web frameworks. Here are the frameworks and their statuses:

* [Vapor](https://github.com/vapor/vapor) - Turnstile is integrated directly into Vapor.
* [Perfect](https://github.com/PerfectlySoft/Perfect) - The [Turnstile-Perfect](https://github.com/stormpath/Turnstile-Perfect) integration allows you to use Turnstile with Perfect. 
* [Zewo](http://www.zewo.io) - A [Zewo integration](https://github.com/Zewo/TurnstileMiddleware) is in development.
* [Kitura](https://github.com/IBM-Swift/Kitura) - A Kitura integration is planned.

# Using Turnstile

If you'd like to use Turnstile to build your own integration, it's useful to understand key concepts in Turnstile. 

## Subject

The `Subject` represents the currently operating user for your application. You'll use this to interact with Turnstile, and safely check if the current user is authenticated properly. 

The Subject API in Turnstile also supports registration, however this is a convenience for basic use cases. Since different apps have different rules on registration and user managment, it's expected that you will most likely write your own registration and user management logic.

## Realm

A realm connects Turnstile to your data store, and allows Turnstile to authenticate and register accounts. Included with Turnstile is a `MemoryRealm`, as well as a `WebMemoryRealm` which can handle username/password pairs, as well as Facebook and Google login. 

The MemoryRealms store information in memory, and will be wiped when the application is restarted. 

To write your own Realm, you'll need to implement the `Realm` protocol, which is defined as: 

```Swift
public protocol Realm {
  func authenticate(credentials: Credentials) throws -> Account
  func register(credentials: Credentials) throws -> Account
}
```

Turnstile provides `Credentials` objects for common use cases, like `UsernamePassword`, `APIKey`, and `AccessToken`. Feel free to define a custom type as well. 

When Turnstile calls the `authenticate` or `register` functions, your Realm should check the Credential type and make sure that it's a credential type you support. If not, it should `throw UnsupportedCredentialsError()`.

Afterwards, your Realm should check if the credentials are valid. If not, it should `throw IncorrectCredentialsError()`.

If the credentials are correct, you should then authenticate the user, and return the account object. The account protocol is simple:

```Swift
public protocol Account {
    var uniqueID: String { get }
}
```

And voila! You've created your first Realm!

## SessionManager

SessionManager is a Turnstile component that manages sessions and persistience for your authentication system. Included with Turnstile is a `MemorySessionmanager`, which can persist sessions in memory. 

If you're building your own, you'll need to implement the `SessionManager` protocol. This is defined as:

```Swift
public protocol SessionManager {
    /// Creates a session for a given Account object and returns the identifier.
    func createSession(account: Account) -> String
    
    /// Gets the account ID for the current session identifier.
    func restoreAccount(fromSessionID identifier: String) throws -> Account

    /// Destroys the session for a session identifier.
    func destroySession(identifier: String)
}
```

When an account is authenticated, and is asks to use the session manager to persist its data, Turnstile calls `createSession(account:)` and expects the Session Manager to return a SessionID it can use to restore the account. While you can use whatever you want as a Session ID, we recommend using TurnstileCrypto's `Random.secureToken` method to generate a random string with 128 bits of entropy. 

When a user comes in with the SessionID, Turnstile calls `restoreAccount(fromSessionID:)` and expects the session manager to return the associated account. Note that this can be different from the account in the Realm, since you might not want to make a database call on every request. If the session does not exist, the Session Manager should `throw InvalidSessionError()`

When the user logs out, `destroySession(identifier:)` should delete the session from the session store. 

# Turnstile Web

Turnstile Web provides a number of helpers to make authentication for websites easier. TurnstileWeb includes plugins for external login providers, like Facebook and Google. 

## Authenticating with Facebook or Google

The Facebook and Google Login flows look like the following:

1. Your web application redirects the user to the Facebook / Google login page, and saves a "state" to prevent a malicious attacker from hijacking the login session. 
2. The user logs in.
3. Facebook / Google redirects the user back to your application. 
4. The application validates the Facebook / Google token as well as the state, and logs the user in. 

### Create a Facebook Application

To get started, you first need to [register an application](https://developers.facebook.com/?advanced_app_create=true) with Facebook. After registering your app, go into your app dashboard's settings page. Add the Facebook Login product, and save the changes. 

In the `Valid OAuth redirect URIs` box, type in a URL you'll use for step 3 in the OAuth process. (eg, `http://localhost:8080/login/facebook/consumer`)

### Create a Google Application

To get started, you first need to [register an application](https://console.developers.google.com/project) with Google. Click "Enable and Manage APIs", and then the [credentials tab](https://console.developers.google.com/apis/credentials). Create an OAuth Client ID for "Web".

Add a URL you'll use for step 3 in the OAuth process to the `Authorized redirect URIs` list. (eg, `http://localhost:8080/login/google/consumer`)

### Initiating the Login Redirect

TurnstileWeb has `Facebook` and `Google` objects, which will allow a you to set up your configured application and log users in. To initialize them, use the client ID and secret (sometimes called App ID) from your Facebook or Google developer console:

```Swift
let facebook = Facebook(clientID: "clientID", clientSecret: "clientSecret")
let google = Google(clientID: "clientID", clientSecret: "clientSecret")
```

Then, generate a state (you can use Random.secureToken to generate a random string), save it (we recommend setting a cookie on your user's browser), and redirect the user:

```Swift
// Redirect the user to this URL using your web framework:
facebook.getLoginLink(redirectURL: "http://localhost:8080/login/google/consumer", state: state)
```

### Consuming the Login Response

Once the user is redirected back to your application, you can now verify that they've properly authenticated using the `state` from the earlier step, and the full URL that the user has been redirected to:

```Swift
let credentials = try facebook.authenticate(authorizationCodeCallbackURL: url, state: state) as! FacebookAccount
let credentials = try google.authenticate(authorizationCodeCallbackURL: url, state: state) as! GoogleAccount
```

These can throw the following errors:

* `InvalidAuthorizationCodeError` if the Authorization Code could not be validated
* `APIConnectionError` if we cannot connect to the OAuth server
* `InvalidAPIResponse` if the server does not respond in a way we expect
* `OAuth2Error` if the OAuth server calls back with an error


If successful, it will return a `FacebookAccount` or `GoogleAccount`. These implement the `Credentials` protocol, so then can be passed back into your application's Realm for further validation.

# TurnstileCrypto

Turnstile Crypto has tools to help you build authentication in your apps. Specifically, it can help you use BCrypt hashing in your app, as well as generate secure random numbers. Documentation is in the files themselves. 

# Tests

Tests are powered by XCTest. To successfully perform the Facebook Login tests, you must have the following environment variables set:

* `FACEBOOK_CLIENT_ID` - the Facebook App ID for a test app from the [Facebook developer console](https://developers.facebook.com). 
* `FACEBOOK_CLIENT_SECRET` - the Facebook App Secret for a test app from the [Facebook developer console](https://developers.facebook.com). 

# Contributing

We're always open to contributions! Feel free to join the [Stormpath slack channel](https://talkstormpath.shipit.xyz) to discuss how you can contribute!

# Stormpath

Turnstile is built by [Stormpath](https://stormpath.com), an API service for authentication, authorization, and user management. If you're building a website, API, or app, and need to build authentication and user management, consider using Stormpath for your needs. We're always happy to help!
