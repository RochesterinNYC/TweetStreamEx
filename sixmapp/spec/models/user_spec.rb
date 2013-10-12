require 'spec_helper'

describe User do

	let(:user) { User.create(
		name: "Some name",
		email: "email@example.com"
	)}

	describe "basic user" do
		it "is valid" do
			user.should be_valid
		end

		it "is invalid without an email" do
			user.email = nil
			user.should_not be_valid
		end

		it "is invalid without a name" do
			user.name = nil
			user.should_not be_valid
		end
	end
end
