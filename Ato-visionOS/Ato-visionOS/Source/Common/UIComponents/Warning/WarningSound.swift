import AVFoundation

// MARK: - WarningSound
/// warning.mp3 파일 재생
struct WarningSound {
    static let shared = WarningSound()
    
    private let audioPlayer: AVAudioPlayer? = {
        guard let soundURL = Bundle.main.url(forResource: "warning", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            player.prepareToPlay()
            return player
        } catch {
            print("Error loading sound: \(error)")
            return nil
        }
    }()
    
    func playWarningSound() {
        audioPlayer?.play()
    }
}