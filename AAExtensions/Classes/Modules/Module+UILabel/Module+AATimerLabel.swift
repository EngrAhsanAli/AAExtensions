//
//  Module+AATimerLabel.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


/// AATimerLabel
open class AATimerLabel: UILabel {
    
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
