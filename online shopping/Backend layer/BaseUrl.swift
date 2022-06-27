//
//  BaseUrl.swift
//  online shopping
//
//  Created by Mohamed Ali on 24/06/2022.
//

import Foundation
import Apollo

let url = URL(string: "https://e269-156-221-85-119.eu.ngrok.io/")
let apollo = ApolloClient(url: url!)


protocol mine {
    
}

extension AllproducsQuery.Data.Category.Product : mine {
    
}

extension AllproducsWithColthesTagQuery.Data.Category.Product : mine {
    
}

extension AllproducsWithTechTagQuery.Data.Category.Product : mine {
    
}
