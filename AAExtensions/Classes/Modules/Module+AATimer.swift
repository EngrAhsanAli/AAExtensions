//
//  Module+AATimer.swift
//  AAExtensions
//
//  Created by Ahsan Ali on 01/06/2019.
//

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
