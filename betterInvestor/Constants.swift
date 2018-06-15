//
//  Constants.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-15.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation

class Constants {
    
    // static let bsae_url = "https://betterinvestor-dev.herokuapp.com/services/v1/";
    static let bsae_url = "http://127.0.0.1:5000/services/v1/";

    static let segmentControlHeight = 20;
    static let segmentViewHeight = 30;
    static let pageViewHeight = 190;
    static let pageControlHeight = 30;
    static let adViewHeight = 50;
    static let get_profile_url = "user/portfolio/";
    static let get_ranking_url = "user/portfolio/rankings/{mode}/{user_id}";
    static let get_gains_url = "user/portfolio/gains/{user_id}";
    static let get_quotes_url =  "market/stock/quote/array/{symbols}";
    static let get_quote_url =  "market/stock/quote/{symbol}";
    static let notif_stocks_updated = "quotes_updated";
    static let status_success = "200";
}
