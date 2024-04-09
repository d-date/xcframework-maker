public struct ModifyMinVersionInfoIfNeeded {
  var run: (Path, Path, Log?) throws -> Void

  public func callAsFunction(
    device: Path,
    simulator: Path,
    _ log: Log? = nil
  ) throws {
    try run(device, simulator, log)
  }
}

public extension ModifyMinVersionInfoIfNeeded {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { deviceFramework, simulatorFramework, log in
      log?(.normal, "[ModifyMinVersionInfoIfNeeded]")
      log?(.verbose, "- deviceFramework: \(deviceFramework.string)")
      log?(.verbose, "- simulatorFramework: \(simulatorFramework.string)")

      let deviceBinary = deviceFramework.addingComponent(deviceFramework.filenameExcludingExtension)
      if !isBuildVersionExist(shellOut: try runShellCommand("otool -l \(deviceBinary.string)", log?.indented())) {
        _ = try runShellCommand("vtool -set-build-version 2 11 11 \(deviceBinary.string) -output \(deviceBinary.string)", log?.indented())
      }

      let simulatorBinary = simulatorFramework.addingComponent(simulatorFramework.filenameExcludingExtension)
      if !isBuildVersionExist(shellOut: try runShellCommand("otool -l \(simulatorBinary.string)", log?.indented())) {
        _ = try runShellCommand("vtool -set-build-version 7 11 11 \(simulatorBinary.string) -output \(simulatorBinary.string)", log?.indented())
      }
    }
  }

  private static func isBuildVersionExist(shellOut: String) -> Bool {
    shellOut.contains("LC_VERSION_MIN_IPHONEOS")
    || shellOut.contains("LC_BUILD_VERSION")
  }
}
