class RelationshipsController < ApplicationController
  before_action :logged_in_user

  # Having updated the form, we now need to arrange for
  # the Relationships controller to respond to Ajax requests.
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # if we do not have a template, rails will raise an exception
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
