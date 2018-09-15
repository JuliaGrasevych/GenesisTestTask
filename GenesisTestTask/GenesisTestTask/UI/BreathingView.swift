//
//  BreathingView.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import UIKit

protocol BreathingViewDelegate: class {
    func attemptToStartBreathing(on view: BreathingView)
    func didFinishPhase(on view: BreathingView)
}

class BreathingView: UIView {
    enum State {
        case unknown
        case`default`
        case animating(phase: Phase)
        
        var scaleFactor: CGFloat? {
            switch self {
            case .unknown: return 1.0
            case .default: return 0.75
            case .animating(let phase): return phase.type.scaleFactor
            }
        }
    }
    
    weak var delegate: BreathingViewDelegate?
    
    private let defaultDuration = 1.0
    
    @IBOutlet private var phaseTitle: UILabel!
    @IBOutlet private var breathingView: UIView!
    
    private var duration: TimeInterval = 0
    private var timer: Timer?
    private var phase: Phase?
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    // MARK: - State configuration
    func setup(state: State) {
        switch state {
        case .unknown, .default:
            restoreDefault(state: state)
        case .animating(let phase):
            start(phase: phase)
        }
    }
    
    // MARK: - Private functions
    // MARK: - Initializers
    private func defaultInit() {
        guard let contentView = UINib.load(class: type(of: self), viewType: UIView.self, owner: self) else {
            return
        }
        addSubview(contentView)
        NSLayoutConstraint.scaleToFillParent(childView: contentView)
    }
    // MARK: - State configuration
    private func restoreDefault(state: State) {
        let completion: ((Bool) -> Void)? = {
            switch state {
            case .default:
                return { (result: Bool) in
                    self.delegate?.attemptToStartBreathing(on: self)
                }
            default: return nil
            }
        }()
        phaseTitle.text = nil
        breathingView.backgroundColor = .yellow
        transformView(to: state, withDuration: defaultDuration, completion: completion)
    }
    private func start(phase: Phase) {
        resetTimer()
        self.phase = phase
        duration = phase.duration
        breathingView.backgroundColor = phase.color
        transformView(to: .animating(phase: phase), withDuration: duration)
        // start timer to update title
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(_:))
        timer?.fire()
    }
    private func transformView(to state: State, withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        // animate view if needed
        if let scaleFactor = state.scaleFactor {
            let transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
            UIView.animate(withDuration: duration,
                           animations: {
                            self.breathingView.transform = transform
            },
                           completion: completion)
        }
    }
    // MARK: - Timer functions
    private func updateTimer(_ timer: Timer) {
        guard duration > 0 else {
            phase = nil
            resetTimer()
            delegate?.didFinishPhase(on: self)
            return
        }
        duration -= 1
        phaseTitle.text = phase?.displayTitle(at: duration)
    }
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}
