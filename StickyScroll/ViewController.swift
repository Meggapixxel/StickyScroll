//
//  ViewController.swift
//  StickyScroll
//
//  Created by Vadim Zhydenko on 15.11.2020.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = true
        tableViewTopConstraint.constant = LocalConstans.maxConst
    }
    
}

private extension ViewController {
    
    struct LocalConstans {
        
        static var minConst: CGFloat { 0 }
        static var maxConst: CGFloat { UIScreen.main.bounds.height / 4 }
        
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewDelegate = scrollView.delegate
        scrollView.delegate = nil
        defer {
            scrollView.delegate = scrollViewDelegate
        }
        
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView)
        if velocity.y == 0 {
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if translation.y > 0 && scrollView.contentOffset.y > 0 {
                print("decelarating ↓", scrollView.contentOffset.y)
            } else {
                print("decelarating ↑", scrollView.contentOffset.y)
            }
        } else {
            if velocity.y > 0 {
                // dragging ↓
                guard scrollView.contentOffset.y < 0 && tableViewTopConstraint.constant != LocalConstans.maxConst else { return }
                if tableViewTopConstraint.constant - scrollView.contentOffset.y > LocalConstans.maxConst {
                    scrollView.contentOffset.y = (LocalConstans.maxConst - tableViewTopConstraint.constant) - scrollView.contentOffset.y
                    tableViewTopConstraint.constant = LocalConstans.maxConst
                } else {
                    tableViewTopConstraint.constant -= scrollView.contentOffset.y
                    scrollView.contentOffset.y = 0
                }
            } else {
                // dragging ↑
                guard scrollView.contentOffset.y > 0 && tableViewTopConstraint.constant != LocalConstans.minConst else { return }
                if tableViewTopConstraint.constant - scrollView.contentOffset.y < LocalConstans.minConst {
                    scrollView.contentOffset.y = scrollView.contentOffset.y - tableViewTopConstraint.constant
                    tableViewTopConstraint.constant = LocalConstans.minConst
                } else {
                    tableViewTopConstraint.constant -= scrollView.contentOffset.y
                    scrollView.contentOffset.y = 0
                }
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(velocity.y, targetContentOffset.pointee.y)
        
        if velocity.y > 0 {
            guard targetContentOffset.pointee.y > 0 && tableViewTopConstraint.constant != LocalConstans.minConst else { return }
            tableViewTopConstraint.constant = LocalConstans.minConst
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else if velocity.y < 0 {
            guard targetContentOffset.pointee.y == 0 else { return }
            if tableViewTopConstraint.constant == LocalConstans.maxConst {
                
            } else {
                if tableViewTopConstraint.constant > LocalConstans.maxConst / 2 {
                    tableViewTopConstraint.constant = LocalConstans.maxConst
                } else {
                    tableViewTopConstraint.constant = LocalConstans.minConst
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            if tableViewTopConstraint.constant > LocalConstans.maxConst / 2 {
                tableViewTopConstraint.constant = LocalConstans.maxConst
            } else {
                tableViewTopConstraint.constant = LocalConstans.minConst
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = indexPath.description
        return cell
    }
    
}
