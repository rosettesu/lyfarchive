class RegistrationFormController < ApplicationController
  include Wicked::Wizard

  beginning_steps = %w[begin returning]
  end_steps = %w[review payment submit]
  all_steps = beginning_steps | Parent.reg_steps | Camper.reg_steps |
              Registration.reg_steps | end_steps
  steps *all_steps

  def show
    case step
    when "begin"
      session[:parent] = nil
      session[:camper] = nil
    when "returning"
      @camper = Camper.new(session[:camper])
    when "parent"
      @parent = Parent.new(session[:parent])
      @parent.valid? if session[:errors]
    else
      @parent = Parent.new(session[:parent])
    end
    session[:errors] = nil
    render_wizard
  end

  def update
    case step
    when "returning"
      year = params[:camper]["birthdate(1i)"].to_i
      month = params[:camper]["birthdate(2i)"].to_i
      date = params[:camper]["birthdate(3i)"].to_i
      @camper = Camper.find_by(first_name: params[:camper][:first_name],
                               last_name: params[:camper][:last_name],
                               birthdate: Date.new(year, month, date))
      if @camper
        session[:parent] = @camper.parent.attributes
        session[:camper] = @camper.attributes
        flash[:info] = "Please make sure the following information is up to date."
        redirect_to next_wizard_path
      else
        @camper = Camper.new(first_name: params[:camper][:first_name],
                             last_name: params[:camper][:last_name],
                             birthdate: Date.new(year, month, date))
        session[:camper] = @camper.attributes
        message = "This camper could not be found. "
        message += "Please check that all fields are correct; "
        message += "otherwise go back and start a new registration."
        flash[:warning] = message
        redirect_to wizard_path
      end
    when "parent"
      @parent = Parent.new(session[:parent])
      @parent.assign_attributes(parent_params(step))
      session[:parent] = @parent.attributes
      session[:errors] = true
      redirect_to @parent.valid? ? next_wizard_path : wizard_path
    end
  end

  private
    def parent_params(step)
      permitted_attrs = case step
        when "parent"
          [:first_name, :last_name, :email, :phone_number, :street, :city, :state, :zip]
        when "referral"
          [:referral_method, :referral_details]
        end
      params.require(:parent).permit(permitted_attrs).merge(reg_step: step)
    end

    def camper_params(step)
      permitted_attrs = case step
        when "camper"
          [:first_name, :last_name, :gender, :birthdate, :email]
        when "medical"
          [:medical, :diet_allergies]
        end
      params.require(:camper).permit(permitted_attrs).merge(reg_step:step)
    end

    def registration_params(step)
      permitted_attrs = case step
        when "camper"
          [:grade]
        when "shirt"
          [:shirt_size]
        when "bus"
          [:bus]
        when "notes"
          [:additional_notes]
        when "waiver"
          [:waiver_signature, :waiver_date]
        end
      params.require(:camper).permit(permitted_attrs).merge(reg_step:step)
    end
end
