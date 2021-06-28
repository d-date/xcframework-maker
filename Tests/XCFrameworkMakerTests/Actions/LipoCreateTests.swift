import XCTest
@testable import XCFrameworkMaker

final class LipoCreateTests: XCTestCase {
  enum Action: Equatable {
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = LipoCreate.live(runShellCommand: .init { command, _ in
      performedActions.append(.didRunShellCommand(command))
      return ""
    })
    let inputs = [Path("input/file1"), Path("input/file2")]
    let output = Path("output/file")
    let log = Log { level, message in
      performedActions.append(.didLog(level, message))
    }

    try sut(inputs: inputs, output: output, log)

    XCTAssertEqual(performedActions, [
      .didLog(.normal, "[LipoCreate]"),
      .didLog(.verbose, "- inputs: \n\t\(inputs.map(\.string).joined(separator: "\n\t"))"),
      .didLog(.verbose, "- output: \(output.string)"),
      .didRunShellCommand("lipo input/file1 input/file2 -create -output output/file")
    ])
  }
}
