//
//  AppFont.swift
//  SetaiTV
//
//  Created by Andriy Vahniy on 11/30/18.
//  Copyright © 2018 Andriy Vahniy. All rights reserved.
//

import UIKit

enum AppFont: String {
	case roboto = "Roboto"
	
	//MARK: Public
	
	func black(_ size: Double)        -> UIFont  { return self.font(forStyle: .black, with: size) }
	func blackItalic(_ size: Double)  -> UIFont  { return self.font(forStyle: .blackItalic, with: size) }
	func bold(_ size: Double)         -> UIFont  { return self.font(forStyle: .bold, with: size) }
	func boldItalic(_ size: Double)   -> UIFont  { return self.font(forStyle: .boldItalic, with: size) }
	func italic(_ size: Double)       -> UIFont  { return self.font(forStyle: .italic, with: size) }
	func light(_ size: Double)        -> UIFont  { return self.font(forStyle: .light, with: size) }
	func lightItalic(_ size: Double)  -> UIFont  { return self.font(forStyle: .ligthItalic, with: size) }
	func medium(_ size: Double)       -> UIFont  { return self.font(forStyle: .medium, with: size) }
	func mediumItalic(_ size: Double) -> UIFont  { return self.font(forStyle: .mediumItalic, with: size) }
	func regular(_ size: Double)      -> UIFont  { return self.font(forStyle: .regular, with: size) }
	func thin(_ size: Double)         -> UIFont  { return self.font(forStyle: .thin, with: size) }
	func thinItalic(_ size: Double)   -> UIFont  { return self.font(forStyle: .thinItalic, with: size) }
}

//MARK: Creation

extension AppFont {
	
	enum Style: String {
		case black        = "Black"
		case blackItalic  = "BlackItalic"
		case bold         = "Bold"
		case boldItalic   = "BoldItalic"
		case italic       = "Italic"
		case light        = "Light"
		case ligthItalic  = "LightItalic"
		case medium       = "Medium"
		case mediumItalic = "MediumItalic"
		case regular      = "Regular"
		case thin         = "Thin"
		case thinItalic   = "ThinItalic"
	}
	
	func font(forStyle style: Style, with size: Double) -> UIFont {
		let name = self.fontName(for: style)
		let cgSize = CGFloat(size)
		
		return UIFont(name: name, size: cgSize) ?? UIFont.systemFont(ofSize: cgSize)
	}
	
	private func fontName(for style: Style) -> String {
		var name: String!
		
		switch self {
		case .roboto: name = "\(self.rawValue)-\(style.rawValue)"
		}
		
		return name
	}
}

