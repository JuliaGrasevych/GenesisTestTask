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
    
    @IBOutlet private var remainingCounter: UILabel!
    @IBOutlet private var breathingView: BreathingView!
    @IBOutlet private var startButton: UIButton!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        phases = phaseProvider?.phases()
        breathingView.delegate = self
        breathingView.setup(state: .unknown)
    }
    
    // MARK: - Interface handlers
    @IBAction private func startBreathing(_ sender: UIButton) {
        startButton.isHidden = true
        breathingView.setup(state: .default)
    }
}
// MARK: - BreathingView Delegate
extension BreathingViewController: BreathingViewDelegate {
    func attemptToStartBreathing(on view: BreathingView) {
        startNextPhase(on: view)
    }
    func didFinishPhase(on view: BreathingView) {
        startNextPhase(on: view)
    }
    private func startNextPhase(on view: BreathingView) {
        if phases?.isEmpty == false,
            let nextPhase = phases?.removeFirst() {
            view.setup(state: .animating(phase: nextPhase))
        } else {
            view.setup(state: .unknown)
        }
    }
}

