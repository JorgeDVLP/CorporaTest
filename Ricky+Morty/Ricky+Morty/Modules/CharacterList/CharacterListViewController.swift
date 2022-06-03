//
//  CharacterListViewController.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class CharacterListViewController: UIViewController, StoryBoarded {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: CharacterListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindView()
        self.viewModel.fetchData()
    }
    
    private func configureCollectionView() {
        self.collectionView.register(CharacterCollectionViewCell.nib(), forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = UIView(frame: CGRect.zero)
        self.collectionView.dataSource = self
    }
    
    private func bindView() {
        self.viewModel.onDataFetched = {
            self.collectionView.reloadData()
        }
    }
}

extension CharacterListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(forSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.getItem(forIndex: indexPath)
        cell.nameLabel.text = item.name
        cell.statusLabel.text = item.status.rawValue
        cell.originLabel.text = item.origin
        
        switch item.status {
        case .alive:
            cell.statusLabel.textColor = UIColor(named: "GreenColor")
        case .dead:
            cell.statusLabel.textColor = UIColor.red
        case .unknown:
            cell.statusLabel.textColor = UIColor.gray
        }
        
        return cell
    }
}

