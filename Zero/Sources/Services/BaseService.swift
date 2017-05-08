//
//  BaseService.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

class BaseService {
  unowned let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
