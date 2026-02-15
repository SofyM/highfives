class UsersController < ApplicationController
  def index
    # Stub: return mock users
    @users = [
      { 'id' => 'alice-johnson', 'first_name' => 'Alice', 'last_name' => 'Johnson', 'email' => 'alice@example.com', 'custom_attributes' => { 'team' => 'Engineering' } },
      { 'id' => 'bob-smith', 'first_name' => 'Bob', 'last_name' => 'Smith', 'email' => 'bob@example.com', 'custom_attributes' => { 'team' => 'Design' } },
      { 'id' => 'carol-williams', 'first_name' => 'Carol', 'last_name' => 'Williams', 'email' => 'carol@example.com', 'custom_attributes' => { 'team' => 'Product' } },
      { 'id' => 'david-brown', 'first_name' => 'David', 'last_name' => 'Brown', 'email' => 'david@example.com', 'custom_attributes' => { 'team' => 'Engineering' } },
      { 'id' => 'emma-davis', 'first_name' => 'Emma', 'last_name' => 'Davis', 'email' => 'emma@example.com', 'custom_attributes' => { 'team' => 'Marketing' } },
      { 'id' => 'frank-miller', 'first_name' => 'Frank', 'last_name' => 'Miller', 'email' => 'frank@example.com', 'custom_attributes' => { 'team' => 'Sales' } }
    ]
    render template: 'users'
  end
end
