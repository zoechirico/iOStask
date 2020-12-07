//
//  share.swift
//  iOStask
//
//  Created by Mike Chirico on 12/5/20.
//

import SwiftUI
func share(items: [Any],
                 excludedActivityTypes: [UIActivity.ActivityType]? = nil) {

        let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
