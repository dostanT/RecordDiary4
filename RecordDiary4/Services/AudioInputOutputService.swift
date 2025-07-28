//
//  AudioInputOutputService.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 16.07.2025.
//
import AVFoundation
import Foundation
import Combine

class AudioInputOutputService: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @Published var audioLevels: [CGFloat] = Array(repeating: 0.2, count: 30)
    @Published var currentEmotion: EmotionModel?
    @Published var recordings: [RecordDataModel] = []

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var meterTimer: Timer?

    func startRecording(emotion: EmotionModel){
        currentEmotion = emotion
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let filename = "Recording_\(formatter.string(from: Date())).m4a"
        print("FileName(Saving): \(filename)")

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
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            startMeterTimer()
        } catch {
            print("Recording failed: \(error)")
        }
    }

    func stopRecording(shownDate: Date) -> RecordDataModel? {
        guard let recorder = audioRecorder, let emotion = currentEmotion else { return nil }

        recorder.stop()
        stopMeterTimer()
        
        let url = recorder.url
        let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
        let date = attrs?[.creationDate] as? Date ?? Date()
        
        let filename = url.deletingPathExtension().lastPathComponent

        let newRecording = RecordDataModel(
            url: url,
            createdDate: date,
            shownDay: shownDate,
            emotion: emotion,
            nameIdentifier: filename
        )

        audioRecorder = nil
        currentEmotion = nil
        return newRecording
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
        } catch {
            print("Delete failed: \(error)")
        }
    }
    
    func deleteAllRecordings(data: [RecordDataModel]) {
        for recording in data {
            deleteRecording(url: recording.url)
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
    
    func fetchRecordings() {
        print("Start fetching recordings...")
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
            let m4aFiles = files.filter { $0.pathExtension == "m4a" }
            let fetched = m4aFiles.compactMap { url -> RecordDataModel? in
                let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
                let date = attrs?[.creationDate] as? Date ?? Date()
                
                let filename = url.deletingPathExtension().lastPathComponent
                print("FileName(Fetch): \(filename)")
                return RecordDataModel(
                    id: UUID().uuidString,
                    url: url,
                    createdDate: date,
                    shownDay: nil,
                    emotion: nil,
                    nameIdentifier: filename
                )
            }

            recordings = fetched
            print("Records fetched: \(recordings.count)")
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    func giveEmotionsForRecordsWithoutEmotions(recordsLocal: [RecordDataModel]) -> [RecordDataModel] {
        var newRecords: [RecordDataModel] = []
        print("Start giveEmotionsForRecordsWithoutEmotions()")
        var countOfRecordsWithoutEmotions: Int = 0
        fetchRecordings()
        
        let emotion: EmotionModel = EmotionModel.defaultEmotion()
        
        print("Start to check if there is emotion")
        
        for record in recordings {
            if let existing = recordsLocal.first(where: { $0.nameIdentifier == record.nameIdentifier }) {
                let recordToUpdate = RecordDataModel(
                    id: existing.id,
                    url: record.url,
                    createdDate: existing.createdDate,
                    shownDay: existing.shownDay,
                    emotion: existing.emotion,
                    nameIdentifier: existing.nameIdentifier,
                    deletedDay: existing.deletedDay,
                    itemIsDeleted: existing.itemIsDeleted
                )
                
                newRecords.append(recordToUpdate)
            } else {
                countOfRecordsWithoutEmotions += 1
                newRecords.append(
                    RecordDataModel(
                        id: record.id,
                        url: record.url,
                        createdDate: record.createdDate,
                        shownDay: Date(),
                        emotion: emotion,
                        nameIdentifier: record.nameIdentifier,
                        deletedDay: nil,
                        itemIsDeleted: false
                    )
                )
            }
        }
        
        print("Done")
        print("giveEmotionsForRecordsWithoutEmotions() Stats:")
        print("Count of records without emotions: \(countOfRecordsWithoutEmotions)")
        print("All records count: \(newRecords.count)")
        return newRecords
    }
    
    @MainActor
    func getDurationString(from url: URL) async -> String? {
        let asset = AVAsset(url: url)

        do {
            let duration = try await asset.load(.duration)
            let totalSeconds = CMTimeGetSeconds(duration)

            guard totalSeconds.isFinite else { return nil }

            let hours = Int(totalSeconds) / 3600
            let minutes = (Int(totalSeconds) % 3600) / 60
            let seconds = Int(totalSeconds) % 60

            var result = ""
            if hours > 0 {
                result += "\(hours)h "
            }
            if minutes > 0 || hours > 0 {
                result += "\(minutes)min "
            }
            result += "\(seconds)sec"

            return result
        } catch {
            print("Ошибка загрузки длительности: \(error)")
            return nil
        }
    }

}

extension Notification.Name {
    static let playbackFinished = Notification.Name("playbackFinished")
}
