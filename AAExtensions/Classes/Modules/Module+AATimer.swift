//
//  Module+AATimer.swift
//  AAExtensions
//
//  Created by Ahsan Ali on 01/06/2019.
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

/// AATimer
open class AATimer {
    public typealias Tick = () -> Void
    open var timer: Timer?
    private var interval: TimeInterval
    private var repeats: Bool
    private var triggerOnInit: Bool
    private var tick: Tick
    
    public init(interval: TimeInterval, repeats: Bool, triggerOnInit: Bool, onTick: @escaping Tick) {
        self.interval = interval
        self.repeats = repeats
        self.tick = onTick
        self.triggerOnInit = triggerOnInit
    }
    
    open func start(){
        if triggerOnInit {
            update()
        }
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    open func stop(){
        timer?.invalidate()
    }
    
    @objc func update() {
        tick()
    }
}
