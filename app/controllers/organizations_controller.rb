class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :sync]

  def show
  end

  def sync
    redirect_to @organization, notice: 'OO'
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
