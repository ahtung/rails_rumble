class OrganizationsController < ApplicationController
  before_action :set_year, only: [:show, :sync]
  before_action :set_organization, only: [:show, :sync]

  def show
  end

  def sync
    @organization.sync!(@year)
    redirect_to @organization, notice: 'OO'
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def set_year
    @year = params[:year] || 2015
  end
end
