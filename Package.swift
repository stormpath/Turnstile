import PackageDescription

var package = Package(
    name: "Turnstile",
    targets: [
        Target(
            name: "Turnstile",
            dependencies: [.Target(name: "TurnstileCrypto")]),
        Target(
            name: "TurnstileCrypto"),
        Target(
            name: "TurnstileWeb",
            dependencies: [.Target(name: "Turnstile")]),
        ],
    dependencies: [
        .Package(url: "https://github.com/vapor/engine.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/vapor/json.git", majorVersion: 0, minor: 5)
    ]
)
