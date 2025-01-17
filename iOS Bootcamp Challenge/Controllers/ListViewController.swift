//
//  ListViewController.swift
//  iOS Bootcamp Challenge
//
//  Created by Jorge Benavides on 26/09/21.
//

import UIKit

class ListViewController: UICollectionViewController {

    private var pokemons: [Pokemon] = []
    private var resultPokemons: [Pokemon] = []

    // TODO: Use UserDefaults to pre-load the latest search at start

    private var latestSearch: String?

    lazy private var searchController: SearchBar = {
        let searchController = SearchBar("Search a pokemon", delegate: nil)
        searchController.text = latestSearch
        searchController.showsCancelButton = !searchController.isSearchBarEmpty
        return searchController
    }()

    private var isFirstLaunch: Bool = true
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var shouldShowLoader: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setupUI()
    }
    
    // MARK: Setup
    
    private func setup() {
        title = "Pokédex"
        
        // Customize navigation bar.
        guard let navbar = self.navigationController?.navigationBar else { return }
        
        navbar.tintColor = .black
        navbar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navbar.prefersLargeTitles = true
        
        // Set up the searchController parameters.
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        refresh()
    }
    
    private func setupUI() {
        
        // Set up the collection view.
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        
        // Set up the refresh control as part of the collection view when it's pulled to refresh.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.sendSubviewToBack(refreshControl)
        
        // Set up the activity indicator view
        self.view.addSubview(activityIndicator)
        activityIndicator.color = .red
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    // MARK: - UISearchViewController
    
    private func filterContentForSearchText(_ searchText: String) {
        // filter with a simple contains searched text
        resultPokemons = pokemons
            .filter {
                searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
            }
            .sorted {
                $0.id < $1.id
            }

        collectionView.reloadData()
    }

    // TODO: Implement the SearchBar

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCell.identifier, for: indexPath) as? PokeCell
        else { preconditionFailure("Failed to load collection view cell") }
        cell.pokemon = pokemons[indexPath.item]
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "goDetailViewControllerSegue",
            let detailViewController = segue.destination as? DetailViewController,
            let cell = sender as? PokeCell,
            let indexPath = collectionView.indexPath(for: cell)
        else { return }
        let pokemon = pokemons[indexPath.row]
        detailViewController.pokemon = pokemon
    }

    // MARK: - UI Hooks

    @objc func refresh() {
        shouldShowLoader = true

        var pokemons: [Pokemon] = []
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        PokeAPI.shared.get(url: "pokemon?limit=30", onCompletion: { (list: PokemonList?, _) in
            guard let list = list else { return }
            myGroup.leave()
            list.results.forEach { result in
                
                myGroup.enter()
                PokeAPI.shared.get(url: "/pokemon/\(result.id)/", onCompletion: { (pokemon: Pokemon?, _) in
                    guard let pokemon = pokemon else { return }
                    pokemons.append(pokemon)
                    self.pokemons = pokemons
                    myGroup.leave()
                })
            }
            
            myGroup.notify(queue: .main) {
                self.activityIndicator.stopAnimating()
                self.didRefresh()
            }
        })
    }

    private func didRefresh() {
        shouldShowLoader = false

        guard
            let collectionView = collectionView,
            let refreshControl = collectionView.refreshControl
        else { return }

        refreshControl.endRefreshing()

        filterContentForSearchText("")
    }

}
