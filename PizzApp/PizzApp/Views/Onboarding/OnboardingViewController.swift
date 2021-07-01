//
//  OnboardingViewController.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 25/06/21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControll.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
            OnboardingSlide(title: "Delicious pizzas made by best", description: "Our staff prepares the best pizzas and fries made with the highest quality products so that you can enjoy only the best.", image: #imageLiteral(resourceName: "chef")),
            
            OnboardingSlide(title: "Best delivery experiencie", description: "The delivery of our pizzas is safe, reliable and fast, all always from the hand of our delivery men.", image: #imageLiteral(resourceName: "delivery")),
            
            OnboardingSlide(title: "Enjoy your pizza!", description: "Try the delicious flavor of our pizzas and french fries, share with your friends and family and make one day an extraordinary day!", image: #imageLiteral(resourceName: "eating"))
        ]
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "onboarding")
            let controller = storyboard?.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
    
}
