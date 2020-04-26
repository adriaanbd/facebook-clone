class ApplicationController < ActionController::Base
	include DeviseWhitelist
	include UserStatus
	include SetSource
end
