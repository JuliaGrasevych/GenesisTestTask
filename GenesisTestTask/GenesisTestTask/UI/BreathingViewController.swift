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
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        phases = phaseProvider?.phases()
        breathingView.delegate = self
        breathingView.restoreDefault()
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
            view.start(phase: nextPhase)
        }
    }
}

