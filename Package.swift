import PackageDescription

var package = Package(
    name: "Turnstile",
    targets: [
        Target(
            name: "Turnstile",
            dependencies: [.Target(name: "TurnstileCrypto")]),
        Target(
            name: "TurnstileCrypto"),
        ]
)

#if os(Linux)
package.dependencies.append(Package.Dependency.Package(url: "https://github.com/czechboy0/SecretSocks.git", majorVersion: 0, minor: 5))
#endif
