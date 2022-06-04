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
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = UIView(frame: CGRect.zero)
        self.tableView.register(EpisodeTableViewCell.nib(), forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
    }
    
    private func bindView() {
        self.viewModel.onDataFetched = { [weak self] in
            self?.tableView.reloadData()
        }
        
        self.viewModel.onShouldDisplayIndicator = { [weak self] display in
            display == true ? self?.showActivityIndicator() : self?.removeActivityIndicator()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeTableViewCell else {
            return UITableViewCell()
        }
        let item = self.viewModel.getItem(forIndex: indexPath)
        cell.title.text = item.name
        cell.date.text = item.localizedDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.viewModel.getSectionName(index: section)
        return "Season \(section)"
    }
}

extension EpisodesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
