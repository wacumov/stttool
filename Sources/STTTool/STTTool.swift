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

        func run() async throws {
            let audioFrames = try await convertToPCMAudioFrames(
                URL(fileURLWithPath: inputFilePath)
            )

            let whisper = Whisper(fromFileURL:
                URL(fileURLWithPath: modelFilePath)
            )

            let segments = try await whisper.transcribe(audioFrames: audioFrames)
            let output = segments.map(\.text).joined(separator: "\n\n\n")

            try output.write(
                to: URL(fileURLWithPath: outputFilePath),
                atomically: true,
                encoding: .utf8
            )
        }

        func convertToPCMAudioFrames(_ fileURL: URL) async throws -> [Float] {
            let tempURL = URL.makeTempURL()
            let converter = FormatConverter(inputURL: fileURL, outputURL: tempURL, options: .wav16K)
            return try await withCheckedThrowingContinuation { continuation in
                converter.start { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        do {
                            let data = try Data(contentsOf: tempURL)
                            let floats = convertToPCMArray(data)
                            continuation.resume(returning: floats)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                        try? FileManager.default.removeItem(at: tempURL)
                    }
                }
            }
        }

        private func convertToPCMArray(_ data: Data) -> [Float] {
            stride(from: 44, to: data.count, by: 2).map {
                data[$0 ..< $0 + 2].withUnsafeBytes {
                    let short = Int16(littleEndian: $0.load(as: Int16.self))
                    return max(-1.0, min(Float(short) / 32767.0, 1.0))
                }
            }
        }
    }
}

private extension FormatConverter.Options {
    static let wav16K: Self = {
        var options = FormatConverter.Options()
        options.format = .wav
        options.sampleRate = 16000
        options.bitDepth = 16
        options.channels = 1
        options.isInterleaved = false
        return options
    }()
}

private extension URL {
    static func makeTempURL() -> URL {
        URL(fileURLWithPath:
            NSTemporaryDirectory()
        ).appendingPathComponent(
            UUID().uuidString
        )
    }
}
