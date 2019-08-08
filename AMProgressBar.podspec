Pod::Spec.new do |s|
  s.name             = 'AMProgressBar'
  s.version          = '0.1.2'

  s.summary          = 'Elegant progress bar for your iOS app written in Swift.'
  s.homepage         = 'https://github.com/Abdul-Moiz/AMProgressBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Abdul Moiz' => 'abdul.moiz1991@gmail.com' }
  s.source           = { :git => 'https://github.com/Abdul-Moiz/AMProgressBar.git', :tag => s.version.to_s }
  s.platform = :ios, '12.0'
  s.swift_versions = '5'

  s.description      = <<-DESC
    Elegant progress bar for your iOS app written in Swift.

    Features
      * Up-to-date: Swift 5
      * Super easy to use and lightweight
      * `IBInspectable` properties can be customized from `Interface Builder`
      * Global config file to apply same style across app.
  DESC

  s.source_files = 'AMProgressBar/Classes/**/*'
end
