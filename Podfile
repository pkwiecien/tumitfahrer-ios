platform :ios, '7.0'

# ignore all warnings from all pods
inhibit_all_warnings!
link_with ['tumitfahrer', 'tumitfahrerTests']

# pod for a left slide menu
pod 'iOS-Slide-Menu'
# pod for handling networking requests
pod 'AFNetworking', '~> 1.2'
# pod to make interacting with RESTful API simple
pod 'RestKit'
pod 'RestKit/Testing'
# Fix RestKit/Testing Pod after installation
post_install do |installer|
	print "Fixing RestKit/Testing Pod\n"
	system "sed -ie '/RKManagedObjectStore\+RKSearchAdditions/d' ./Pods/RestKit/Code/Testing/RKTestFactory.m"
end

# pod with date selection controller
pod "RMDateSelectionViewController"
# implementation of mock objects
pod 'OCMock'