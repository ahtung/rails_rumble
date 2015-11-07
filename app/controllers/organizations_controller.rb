class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :sync]

  def show
  end

  def sync
    @organization.sync!(2015, current_user)
    redirect_to @organization, notice: 'Sync started'
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
