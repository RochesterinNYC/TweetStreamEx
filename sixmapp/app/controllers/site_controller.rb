class SiteController < ApplicationController
	skip_before_filter :require_user, :only => [:welcome]
	def index
	end

	def welcome
	end
end