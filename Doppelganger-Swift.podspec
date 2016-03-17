Pod::Spec.new do |s|
  s.name             = "Doppelganger-Swift"
  s.version          = "0.1.0"
  s.summary          = "Array diffs as collection view wants it - in Swift."
  s.description      = <<-DESC
                        Animated UITableView and UICollectionView reloading in Swift,
                        natively animated. No more confusing list reloading.
                       DESC
  s.platform         = :ios, "8.0"
  s.homepage         = "http://github.com/nahive/Doppelganger-Swift"
  s.license          = 'MIT'
  s.author           = { "nahive" => "nahive.github.io" }
  s.source           = { :git => "https://github.com/nahive/Doppelganger-Swift.git", :tag => "0.1.0" }
  s.social_media_url = 'https://twitter.com/nahive'

  s.requires_arc = true
  s.source_files = 'Doppelganger-Swift/*.{swift}'

end