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
      if try !runShellCommand("otool -l \(deviceBinary.string)", log?.indented()).contains("LC_VERSION_MIN_IPHONEOS") {
        _ = try runShellCommand("vtool -set-build-version 2 15 15 \(deviceBinary.string)", log?.indented())
      }

      let simulatorBinary = deviceFramework.addingComponent(simulatorFramework.filenameExcludingExtension)
      if try !runShellCommand("otool -l \(simulatorBinary.string)", log?.indented()).contains("LC_VERSION_MIN_IPHONEOS") {
        _ = try runShellCommand("vtool -set-build-version 7 15 15 \(simulatorBinary.string)", log?.indented())
      }
    }
  }
}
