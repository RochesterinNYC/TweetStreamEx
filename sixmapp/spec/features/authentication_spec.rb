require 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'

class FakeSessionsController < ApplicationController
	def create
		session[:user_id] = params[:user_id]
		redirect_to root_path
	end
end

describe 'the application', type: :feature do
	context 'when logged out' do

		before(:each) do
			Rails.application.routes.draw do
				root to: 'dashboard#index'
				get "/dashboard" => 'stream#index', :as => 'dashboard'
				get '/fake_login' => 'fake_sessions#create', as: :fake_login
				# get '/login', to: 'sessions#new', :as => "login"
				match '/login' => redirect('/auth/twitter'), as: :login, via: [:get, :post]
				# match '/login' => redirect('/auth/twitter'), as: :login, via: [:get, :post]
				delete "/logout" => "sessions#destroy", as: :logout
			end
			user_data = {"provider" => 'twitter', "uid" => '1234',
				"info" => {'name' => "Lev Brie"}
			}
			visit root_path
		end

		it 'has a login link' do
			expect(page).to have_link('Sign In', href: login_path)
		end

		it "doesn't have a logout link" do
			expect(page).not_to have_link('Logout', href: logout_path)
		end
	end

	context 'when logged in' do
		before(:each) do
			Rails.application.routes.draw do
				root to: 'dashboard#index'
				get "/dashboard" => 'stream#index', :as => 'dashboard'
				get '/fake_login' => 'fake_sessions#create', as: :fake_login
				# get '/login', to: 'sessions#new', :as => "login"
				match '/login' => redirect('/auth/twitter'), as: :login, via: [:get, :post]
				# match '/login' => redirect('/auth/twitter'), as: :login, via: [:get, :post]
				delete "/logout" => "sessions#destroy", as: :logout
			end
			user_data = {"provider" => 'twitter', "uid" => '1234',
				"info" => {'name' => "Lev Brie"}
			}
			user = User.find_or_create_by_oauth(user_data)
			visit fake_login_path(:user_id => user.id)
		end

		after(:each) do
			Rails.application.reload_routes!
		end

		it 'has a logout link' do
			p page
			expect(page).to have_link('Logout', href: "/logout")
		end

		it "doesn't have a login link" do
			expect(page).not_to have_link('Sign In', href: login_path)
		end
	end
end