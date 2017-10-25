# Metronome

[![CI Status](http://img.shields.io/travis/kupratsevich@gmail.com/Metronome.svg?style=flat)](https://travis-ci.org/kupratsevich@gmail.com/Metronome)
[![Version](https://img.shields.io/cocoapods/v/Metronome.svg?style=flat)](http://cocoapods.org/pods/Metronome)
[![License](https://img.shields.io/cocoapods/l/Metronome.svg?style=flat)](http://cocoapods.org/pods/Metronome)
[![Platform](https://img.shields.io/cocoapods/p/Metronome.svg?style=flat)](http://cocoapods.org/pods/Metronome)

A simple metronome.

## Overview

Metronome view controller that can be embedded into your app and used right away. Metronome implementation itself is based on Apple’s example (<https://developer.apple.com/library/content/samplecode/HelloMetronome/Introduction/Intro.html>).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 9.0+

## Installation

Metronome is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Metronome'
```

## Usage

Simply create an instance of MTRMetronomeViewController and add its view to your view hierarchy.

```objc
@property (strong, nonatomic) MTRMetronomeViewController *metronome;
```
Add to arbitrary UIVIew.
```objc
self.metronome = [[MTRMetronomeViewController alloc] initWithMinBPM:10 maxBPM:100 currentBPM:50];
[self.view addSubview:self.metronome.view];
self.metronome.view.frame = self.view.bounds;
```
Add to UITableViewCell's contentView.
```objc
self.metronomeViewController = [[MTMetronomeViewController alloc] initWithMinBPM:10 maxBPM:100 currentBPM:50];
self.metronomeViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
[self.contentView addSubview:self.metronomeViewController.view];

UILayoutGuide *margin = self.contentView.layoutMarginsGuide;
[self.metronomeViewController.view.topAnchor constraintEqualToAnchor:margin.topAnchor].active = YES;
[self.metronomeViewController.view.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor].active = YES;
[self.metronomeViewController.view.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor].active = YES;
[self.metronomeViewController.view.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor].active = YES;
```

## Author

Yurii Kupratsevych

kupratsevich@gmail.com

## License

Metronome is available under the MIT license. See the LICENSE file for more info.
