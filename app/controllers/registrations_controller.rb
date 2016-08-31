class RegistrationsController < ApplicationController
  layout "fluid", only: [:index]

  def index
    # later: replace year with some kind of current_year var ?
    @registrations = Registration.paginate(page: params[:page])
  end
end
