class ParentsController < ApplicationController

  def show
    @parent = Parent.find(params[:id])
    @campers = @parent.campers
  end
end
