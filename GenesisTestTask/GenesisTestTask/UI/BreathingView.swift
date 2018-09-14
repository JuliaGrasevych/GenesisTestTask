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
    weak var delegate: BreathingViewDelegate?
    
    @IBOutlet private var phaseTitle: UILabel!
    @IBOutlet private var breathingView: UIView!
    @IBOutlet private var breathingViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var breathingViewHeightConstraint: NSLayoutConstraint!
    
    private var duration: TimeInterval = 0
    private var timer: Timer?
    private var phase: Phase?
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    // MARK: - State configuration
    func restoreDefault() {
        breathingView.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        phaseTitle.text = "TAP TO START"
        breathingView.backgroundColor = .yellow
        //TODO: enable recognizer
    }
    
    func start(phase: Phase) {
        resetTimer()
        self.phase = phase
        duration = phase.duration
        breathingView.backgroundColor = phase.color
        // animate view if needed
        if let sizeMultiplier = phase.type.scaleFactor {
            let transform = CGAffineTransform.identity.scaledBy(x: sizeMultiplier, y: sizeMultiplier)
            UIView.animate(withDuration: duration) {
                self.breathingView.transform = transform
            }
        }
        phaseTitle.text = phase.displayTitle(at: duration)
        // start timer to update title
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(_:))
    }
    // MARK: - Interface handlers
    @IBAction func attemptToStart(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.attemptToStartBreathing(on: self)
        tapRecognizer.isEnabled = false
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
    // MARK: - Timer functions
    private func updateTimer(_ timer: Timer) {
        guard duration > 0 else {
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
