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
        ]
)