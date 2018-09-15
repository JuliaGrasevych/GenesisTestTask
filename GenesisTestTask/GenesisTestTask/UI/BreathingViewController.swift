//
//  BreathingViewController.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import UIKit

class BreathingViewController: UIViewController {
    
    var phaseProvider: PhaseProvider?
    
    private var phases: [Phase]?
    private var timer: Timer?
    private var totalDuration: TimeInterval = 0
    private var currentPhaseDuration: TimeInterval = 0
    
    @IBOutlet private var remainingCounter: UILabel!
    @IBOutlet private var breathingView: BreathingView!
    @IBOutlet private var startButton: UIButton!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        phases = phaseProvider?.phases()
        totalDuration = phases?.reduce(0, { return $0 + $1.duration }) ?? 0
        breathingView.delegate = self
        breathingView.setup(state: .unknown)
    }
    
    // MARK: - Interface handlers
    @IBAction private func startBreathing(_ sender: UIButton) {
        startButton.isHidden = true
        breathingView.setup(state: .default)
    }
    
    // MARK: - Timer functions
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(_:))
        timer?.fire()
    }
    private func updateRemaining(_ remaining: TimeInterval?) {
        guard let formattedTime = remaining?.elapsedFormat() else {
            remainingCounter.text = nil
            return
        }
        remainingCounter.text = "Remaining\n\(formattedTime)"
    }
    private func updateTimer(_ timer: Timer) {
        if currentPhaseDuration <= 0 {
            startNextPhase(on: breathingView)
        }
        guard totalDuration > 0 else {
            updateRemaining(nil)
            resetTimer()
            return
        }
        totalDuration -= 1
        currentPhaseDuration -= 1
        // update remaining label
        updateRemaining(totalDuration)
        breathingView.timerTick(at: currentPhaseDuration)
    }
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}
// MARK: - BreathingView Delegate
extension BreathingViewController: BreathingViewDelegate {
    func attemptToStartBreathing(on view: BreathingView) {
        startNextPhase(on: view)
        startTimer()
    }
    private func startNextPhase(on view: BreathingView) {
        if phases?.isEmpty == false,
            let nextPhase = phases?.removeFirst() {
            currentPhaseDuration = nextPhase.duration
            view.setup(state: .animating(phase: nextPhase))
        } else {
            view.setup(state: .unknown)
        }
    }
}

