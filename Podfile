# vim : set ft=ruby :
#

target 'nBack' do
  use_frameworks!

  pod 'SwiftyJSON'

  pod 'RxSwift', '~> 3.2'
  pod 'RxCocoa', '~> 3.2'
  pod 'RxDataSources'
  pod 'RealmSwift'
  pod 'RxRealm'

  pod 'DZNEmptyDataSet'
  pod 'BonMot'
  pod 'Eureka', '~> 2.0.0-beta.1'

  pod 'Hero'

  target 'nBackTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end


  if `whoami`[0...-1] == 'lanza'
    pod 'CoordinatorKit', :path => '~/Documents/CoordinatorKit'
    pod 'Reuse', :path => '~/Documents/Reuse'
  else 
    pod 'CoordinatorKit', :git => 'https://github.com/nathanlanza/CoordinatorKit'
    pod 'Reuse', :git=> 'https://github.com/nathanlanza/Reuse'
  end

  target 'nBackInternal' do
    inherit! :search_paths
  end
end
