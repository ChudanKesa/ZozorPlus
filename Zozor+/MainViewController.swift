//
//  MainViewController.swift
//  CountOnMe
//
//  Created by Erwan Le Querré on 23/01/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Private properties
    
    private lazy var viewModel: MainViewModel = {
        let source = MainSource()
        let viewModel = MainViewModel(source: source)
        return viewModel
    }()
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(to: viewModel)
        
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: MainViewModel) {
        viewModel.displayedText = { [weak self] text in
            self?.textView.text = text
        }
    }
    
    @IBAction func pressOperand(_ sender: UIButton) {
        viewModel.didPressOperand(at: sender.tag)
    }
    
    @IBAction func pressOperator(_ sender: UIButton) {
        viewModel.didPressOperator(at: sender.tag)
    }
    
    @IBAction func pressClear(_ sender: UIButton) {
        viewModel.clear()
    }
    
    
}



