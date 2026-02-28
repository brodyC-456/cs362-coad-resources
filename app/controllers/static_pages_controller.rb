class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:organization_application_submitted]

  def index
  end

  def ticket_submitted
  end

  def organization_expectations
  end

  def organization_application_submitted
  end

end
