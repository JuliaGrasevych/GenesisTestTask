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
    private struct DefaultValues {
        static let duration = 1.0
        static let color = UIColor.yellow
    }
    weak var delegate: BreathingViewDelegate?
    
    private var phase: Phase?
    
    @IBOutlet private var phaseTitle: UILabel!
    @IBOutlet private var breathingView: UIView!
    
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
    func timerTick(at timestamp: TimeInterval) {
        print("timer tick with duration \(timestamp)")
        phaseTitle.text = phase?.displayTitle(at: timestamp)
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
        breathingView.backgroundColor = DefaultValues.color
        transformView(to: state, withDuration: DefaultValues.duration, completion: completion)
    }
    private func start(phase: Phase) {
        print("start Phase \(phase)")
        self.phase = phase
        breathingView.backgroundColor = phase.color
        transformView(to: .animating(phase: phase), withDuration: phase.duration)
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
}
