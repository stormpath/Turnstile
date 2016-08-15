# Turnstile
![Swift](http://img.shields.io/badge/swift-v3.0--dev.07.25-brightgreen.svg)
[![Build Status](https://api.travis-ci.org/stormpath/Turnstile.svg?branch=master)](https://travis-ci.org/stormpath/Turnstile)
[![codecov](https://codecov.io/gh/stormpath/Turnstile/branch/master/graph/badge.svg)](https://codecov.io/gh/stormpath/Turnstile)
[![codebeat badge](https://codebeat.co/badges/ba981396-2a2c-4364-8067-6c128758f3bc)](https://codebeat.co/projects/github-com-stormpath-turnstile)
[![Slack Status](https://talkstormpath.shipit.xyz/badge.svg)](https://talkstormpath.shipit.xyz)

Turnstile is a security framework for Swift inspired by [Apache Shiro](http://shiro.apache.org). It's used to manage the currently executing user account in your application, whether iOS app or backend web application. 

## Overview

Turnstile is the easiest way to add authentication to your Swift apps. Currently, the focus is on a great API for backend Swift apps. 

Turnstile is split into three projects:

* Turnstile Core - provides key components for authentication and security. 
* Turnstile Crypto - tools for generating randomness, hashing, and encrypting data
* Turnstile Web - integrations with Facebook, Google, and other helpers useful for backend web applications. 

This document describes Turnstile Core -- however, many developers using Turnstile will most likely want to read the docs for Turnstile Web for Facebook / Google login. 

## Getting Started

The easiest way to use Turnstile is with one of its prebuilt integrations with Swift web frameworks. Currently, an integration with Vapor is in development, but integrations with Kitura and Perfect are planned. We'd love help building more integrations! 

## Concepts

If you'd like to use Turnstile to build your own integration, it's useful to understand key concepts in Turnstile. 

### Turnstile

Turnstile is the main object that manages the relationship between all of the other Turnstile objects. You'd use this API in an integration for a framework / etc, but not as much as an end user of Turnstile. 

### User

The user object represents the currently operating user, also known as "subject" in security terms. This user is the API that the end developer using an integration will interact with to authenticate users.

The user object also supports registration, however this is a convenience for basic uses cases. Since different apps have different user management needs, it's expected that many developers will write their own registration logic, but use Turnstile to authenticate. 

### Realm

A realm connects Turnstile to your data store, and allows Turnstile to authenticate and register accounts. 

To use Turnstile, an end developer will most likely be implementing their own realm. 

### SessionManager

SessionManager is a Turnstile component that manages sessions and persistience for your authentication system. 

## Using

### Writing a Realm

### Writing a SessionManager

## Tests

Tests are powered by XCTest. To successfully perform the Facebook Login tests, you must have the following environment variables set:

* `FACEBOOK_CLIENT_ID` - the Facebook App ID for a test app from the [Facebook developer console](https://developers.facebook.com). 
* `FACEBOOK_CLIENT_SECRET` - the Facebook App Secret for a test app from the [Facebook developer console](https://developers.facebook.com). 

## Contributing

We're always open to contributions! Since this probject is fairly early stage, please join the [Stormpath slack channel](https://talkstormpath.shipit.xyz) to discuss how you can contribute!