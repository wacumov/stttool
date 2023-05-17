import ArgumentParser
import AudioKit
import Foundation
import SwiftWhisper

@main
struct STTTool: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "stttool",
        abstract: "A tool for transcribing audio files to text files using a pretrained model.",
        subcommands: [Transcribe.self]
    )

    func run() async throws {}

    struct Transcribe: AsyncParsableCommand {
        @Argument(help: "Path to the input audio file")
        var inputFilePath: String

        @Argument(help: "Path to the pretrained model")
        var modelFilePath: String

        @Argument(help: "Path to the output text file")
        var outputFilePath: String

        func run() async throws {}
    }
}
