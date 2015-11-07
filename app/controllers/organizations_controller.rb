class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_year, only: [:show, :sync]
  before_action :set_organization, only: [:show, :sync]

  def show
  end

  def sync
    @organization.sync!(@year, current_user)
    redirect_to @organization, notice: 'Sync started'
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def set_year
    @year = params[:year] || Time.now.year
  end
end
