//
//  EpisodesViewController.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class EpisodesViewController: UIViewController, StoryBoarded {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EpisodesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        configureTableView()
        bindView()
        self.viewModel.fetchData()
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func bindView() {
        self.viewModel.onDataFetched = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension EpisodesViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension EpisodesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
