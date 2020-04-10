//
//  Constants.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-15.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation

class Constants {
    
    // TODO: Enable multi-environments
     #if DEV
             static let bsae_url = "https://betterinvestor-dev.herokuapp.com/services/v1/"
         //    static let bsae_url = "http://127.0.0.1:5000/services/v1/"
     #elseif PROD
          static let bsae_url = "https://betterinvestor.herokuapp.com/services/v1/"
      //  static let bsae_url = "http://127.0.0.1:5000/services/v1/"
     //   static let bsae_url = "http://socialtrader-4-ELB-X4W1YPPEHUFV-1767386157.us-east-1.elb.amazonaws.com:5000/services/v1/"
    
     #elseif ADHOC
        static let bsae_url = "https://betterinvestor-staging.herokuapp.com/services/v1/"
     #else
        static let bsae_url = "http://127.0.0.1:5000/services/v1/"
     #endif
    
    
    // static let bsae_url = "https://betterinvestor-dev.herokuapp.com/services/v1/";
    // static let bsae_url = "http://127.0.0.1:5000/services/v1/";

    static let segmentControlHeight = 20;
    static let segmentViewHeight = 30;
    static let pageViewHeight = 210;
    static let pageControlHeight = 30;
    static let adViewHeight = 50;
    static let portfolio_url = "user/portfolio/";
    static let get_ranking_url = "user/portfolio/rankings/{mode}/{user_id}";
    static let get_gains_url = "user/portfolio/gains/{user_id}";
    static let get_quotes_url =  "market/stock/quote/array/{symbols}";
    static let get_quote_url =  "market/stock/quote/{symbol}";
    static let get_holders_url =  "users/holders/{symbol}/global/{isGlobal}/userid/{user_id}";
    static let get_profile_url = "user/profile";
    static let post_credit_url = "user/profile/credit"
    static let notif_stocks_updated = "quotes_updated";
    static let status_success = "200";
    static let admob_id = "ca-app-pub-5267718216518748/5568296429";
    static let product_id_20k = "20k_inapp_cash_credit";
    static let product_id_50k = "50k_inapp_cash_credit";
}
