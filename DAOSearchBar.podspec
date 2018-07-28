Pod::Spec.new do |s|
  s.name         = "DAOSearchBar"
  s.version      = "1.2.5"
  s.summary      = "A search bar with beautiful animation."
  s.homepage     = "https://github.com/daoseng33/DAOSearchBar"
  s.screenshots  = "https://media.giphy.com/media/3o6vXWksaIn9OFF78I/giphy.gif"
  s.license      = "WTFPL"
  s.author = { "daoseng33" => "daoseng33@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/daoseng33/DAOSearchBar.git", :tag => "#{s.version}" }
  s.source_files = 'DAOSearchBar/**/*'
  s.framework    = "UIKit"
  s.resources = 'DAOSearchBar/Resources/DAOSearchBar.bundle'
end