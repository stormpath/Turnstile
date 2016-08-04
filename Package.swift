import PackageDescription

let package = Package(
    name: "Turnstile",
    targets: [
        Target(
            name: "Turnstile",
            dependencies: [.Target(name: "TurnstileCrypto")]),
        Target(
            name: "TurnstileCrypto")
    ]
)
