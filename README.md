# Turnstile
![Swift](http://img.shields.io/badge/swift-v3.0--dev.07.25-brightgreen.svg)
[![Build Status](https://api.travis-ci.org/stormpath/Turnstile.svg?branch=master)](https://travis-ci.org/stormpath/Turnstile)
[![codecov](https://codecov.io/gh/stormpath/Turnstile/branch/master/graph/badge.svg)](https://codecov.io/gh/stormpath/Turnstile)
[![codebeat badge](https://codebeat.co/badges/ba981396-2a2c-4364-8067-6c128758f3bc)](https://codebeat.co/projects/github-com-stormpath-turnstile)
[![Slack Status](https://talkstormpath.shipit.xyz/badge.svg)](https://talkstormpath.shipit.xyz)

Turnstile is a security framework for Swift inspired by [Apache Shiro](http://shiro.apache.org). It's used to manage the currently executing user account in your application, whether iOS app or backend web application. 

Turnstile is currently a work in progress, and the API might change at any time. We're planning on releasing in the next two weeks:

* Documentation
* Full code coverage
* An integration with [Vapor](https://github.com/qutheory/vapor), a Swift web framework
* Turnstile Web, a package with OAuth components for the web. 
* Four core components:
 * Session Management
 * Realms - connecting Turnstile with your application's data
 * User
 * Crypto - a basic API for hashing and generating random data