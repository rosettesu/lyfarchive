class CampersController < ApplicationController
  layout "fluid", only: [:index]

  def index
    @campers = Camper.paginate(page: params[:page])
  end

  def show
    @camper = Camper.find(params[:id])
    @regs = @camper.registrations
    @parent = @camper.parent
  end
end
