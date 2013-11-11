require 'spec_helper'

describe SessionsController do

	# before(:each) do
	# 	Rails.application.routes.draw do
	# 		resource :sessions, :only => [:create]
	# 	end
	# end

	describe "#create" do
		it "creates a user from twitter data and logs them in" do
			@request.env["omniauth.auth"] = {
				'provider' => 'twitter',
				'info' => {'name' => 'Lev Brie'},
				'uid' => '127186'
			}

			post :create
			user = User.find_by(uid: '127186', provider: 'twitter')
			expect(user.name).to eq("Lev Brie")
			expect(controller.current_user.id).to eq(user.id)
		end

		it "logs in an existing user" do
			@request.env["omniauth.auth"] = {
				'provider' => 'twitter',
				'info' => {'name' => 'James Wen'},
				'uid' => 'x4545x'
			}
			user = User.create(provider: 'twitter', uid: 'x4545x', name: 'James Wen')
			post :create
			expect(User.count).to eq(1)
			expect(controller.current_user.id).to eq(user.id)
		end

		it "redirects to the dashboard after login" do
			@request.env["omniauth.auth"] = {
				'provider' => 'twitter',
				'info' => {'name' => 'Lev Brie'},
				'uid' => '127186'
			}
			user = User.find_by_uid_and_provider('127186', 'twitter')
			post :create
			expect(response).to redirect_to(dashboard_path)
		end
	end
end