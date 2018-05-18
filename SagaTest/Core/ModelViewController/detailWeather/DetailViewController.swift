//
//  DetailViewController.swift
//  SagaTest
//
//  Created by Daniel Klinkert Houfer on 5/18/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    let viewModel = DetailWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configureAppearance() {
        locationName.text   = "Name: \(viewModel.detailWeather.name)"
        currentTemp.text    = "Current temperature: \(viewModel.detailWeather.temp) "
        maxTemp.text        = "Max temperature \(viewModel.detailWeather.maxTemp)"
        minTemp.text        = "Min temperature: \(viewModel.detailWeather.minTemp)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
