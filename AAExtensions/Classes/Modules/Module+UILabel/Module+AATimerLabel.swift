//
//  Module+AATimerLabel.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//

public class AATimerLabel: UILabel {
    
    public var seconds: Double = 60
    var isTimerReverse: Bool = false
    var isTimerRunning: Bool = false
    var resumeTapped: Bool = false
    public var timer = Timer()
    
    public func startTimer(_ seconds: Double, _ reverse: Bool) {
        isTimerReverse = reverse
        if isTimerRunning == false {
            self.seconds = seconds
            runTimer()
        }
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    public func resetTimer(_ seconds: Double) {
        timer.invalidate()
        self.seconds = seconds
        self.text = seconds.aa_secondsTommss
        isTimerRunning = false
    }
    
    public func stopTimer() {
        timer.invalidate()
        self.text = "00:00"
        isTimerRunning = false
    }
    
    @objc private func updateTimer() {
        if isTimerReverse {
            if seconds < 1 {
                timer.invalidate()
                //Send alert to indicate time's up.
            } else {
                seconds -= 1
                self.text = seconds.aa_secondsTommss
            }
        } else {
            seconds += 1
            self.text = seconds.aa_secondsTommss
        }
    }
}
