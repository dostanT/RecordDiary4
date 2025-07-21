import SwiftUI
import AVFoundation
import Combine
import Foundation

struct ContentView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var isRecording = false
    @State private var currentlyPlaying: URL?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.black, .gray]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Audio Recorder")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                if isRecording {
                    AudioWaveformView(audioLevels: audioRecorder.audioLevels)
                        .frame(height: 100)
                        .padding()
                }

                Button {
                    isRecording.toggle()
                    if isRecording {
                        audioRecorder.startRecording()
                    } else {
                        audioRecorder.stopRecording()
                    }
                } label: {
                    Circle()
                        .fill(isRecording ? Color.red : Color.green)
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                }

                Text("Recordings")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.top)

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(audioRecorder.recordings) { recording in
                            HStack {
                                Text("Recording \(recording.sequence)")
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    if currentlyPlaying == recording.url {
                                        audioRecorder.stopPlayback()
                                        currentlyPlaying = nil
                                    } else {
                                        audioRecorder.playRecording(url: recording.url) { success in
                                            if success {
                                                currentlyPlaying = recording.url
                                            }
                                        }
                                    }
                                }) {
                                    Image(systemName: currentlyPlaying == recording.url ? "stop.fill" : "play.fill")
                                        .foregroundColor(.white)
                                }
                                Button(action: {
                                    audioRecorder.deleteRecording(url: recording.url)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 300)
            }
            .padding()
        }
        .onAppear {
            audioRecorder.fetchRecordings()
        }
        .onReceive(NotificationCenter.default.publisher(for: .playbackFinished)) { _ in
            currentlyPlaying = nil
        }
    }
}

//extension Notification.Name {
//    static let playbackFinished = Notification.Name("playbackFinished")
//}



class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @Published var recordings: [Recording] = []
    @Published var audioLevels: [CGFloat] = Array(repeating: 0.2, count: 30)

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var meterTimer: Timer?

    func startRecording() {
        let sequence = (recordings.last?.sequence ?? 0) + 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let filename = "Recording_\(sequence)_\(formatter.string(from: Date())).m4a"

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let session = AVAudioSession.sharedInstance()
        do {
            // Настраиваем сессию на запись и воспроизведение через нижний динамик
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            // Создание и запуск записи
            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            startMeterTimer()
        } catch {
            print("Recording failed: \(error)")
        }
    }


    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        stopMeterTimer()
        fetchRecordings()
    }

    func fetchRecordings() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
            let m4aFiles = files.filter { $0.pathExtension == "m4a" }
            let fetched = m4aFiles.compactMap { url -> Recording? in
                let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
                let date = attrs?[.creationDate] as? Date ?? Date()
                let seq = Int(url.lastPathComponent.split(separator: "_").dropFirst().first ?? "0") ?? 0
                return Recording(url: url, date: date, sequence: seq)
            }
            recordings = fetched.sorted { $0.sequence < $1.sequence }
        } catch {
            print("Fetch failed: \(error)")
        }
    }

    func playRecording(url: URL, completion: @escaping (Bool) -> Void) {
        stopPlayback()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            completion(true)
        } catch {
            print("Playback failed: \(error)")
            completion(false)
        }
    }



    func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    func deleteRecording(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            fetchRecordings()
        } catch {
            print("Delete failed: \(error)")
        }
    }

    private func startMeterTimer() {
        meterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.updateAudioLevels()
        }
    }

    private func stopMeterTimer() {
        meterTimer?.invalidate()
        meterTimer = nil
    }

    private func updateAudioLevels() {
        guard let recorder = audioRecorder else { return }
        recorder.updateMeters()
        let average = recorder.averagePower(forChannel: 0)
        let normalized = normalizedPowerLevel(fromDecibels: average)

        DispatchQueue.main.async {
            self.audioLevels.append(normalized)
            if self.audioLevels.count > 30 {
                self.audioLevels.removeFirst()
            }
        }
    }

    private func normalizedPowerLevel(fromDecibels decibels: Float) -> CGFloat {
        if decibels < -80 {
            return 0
        } else if decibels >= 0 {
            return 1
        } else {
            return CGFloat((decibels + 80) / 80)
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: .playbackFinished, object: nil)
    }
}

struct AudioWaveformView: View {
    var audioLevels: [CGFloat]

    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(audioLevels, id: \.self) { level in
                Capsule()
                    .fill(Color.green)
                    .frame(width: 3, height: max(2, level * 100))
            }
        }
    }
}
