class RegistrationFormController < ApplicationController
  include Wicked::Wizard

  beginning_steps = %w[begin returning]
  end_steps = %w[siblings payment submit]
  all_steps = beginning_steps | Parent.reg_steps | Camper.reg_steps |
              Registration.reg_steps | end_steps
  steps *all_steps

  def show
    @steps = steps
    @current_step = step
    case step
    when "begin"
      clear_session
    when "returning"
      @camper = Camper.new(session[:camper])
    when "parent"
      @parent = build_parent_from_session
      @parent.valid? if form_has_errors?
    when "referral"
      if session[:parent_id].nil?
        @parent = build_parent_from_session
        @rm_ids = @parent.referrals.collect{|r| r.referral_method_id}
        @referrals = initialize_referrals(@parent)
        @parent.valid? if form_has_errors?
      else
        skip_step
      end
    when "camper"
      @camper = build_camper_from_session
      @camper.valid? if form_has_errors?
    when "details"
      @reg = build_reg_from_session
      @reg.valid? if form_has_errors?
    when "waiver"
      @reg = build_reg_from_session
      @reg.valid? if form_has_errors?
    when "review"
      @camper = build_camper_from_session
      @reg = build_reg_from_session
    when "siblings"
      parent_id = session[:parent]["id"]
      camper_ids = session[:campers].collect{ |c| c["id"] }
      @regs = session[:campers].collect{ |c| c["first_name"]+" "+c["last_name"]}
      @siblings = []
      unless parent_id.nil?
        Camper.where(parent: parent_id).where(status: :active).
                                        where.not(id: camper_ids).each do |c|
          @siblings << c
        end
      end
    when "payment"
      @parent = build_parent_from_session
    end
    reset_errors
    render_wizard
  end

  def update
    case step
    when "returning"
      # TODO: handle missing form fields
      firstname = params[:camper][:first_name]
      lastname = params[:camper][:last_name]
      year = params[:camper]["birthdate(1i)"].to_i
      month = params[:camper]["birthdate(2i)"].to_i
      date = params[:camper]["birthdate(3i)"].to_i
      birthdate = Date.new(year, month, date)
      @camper = Camper.find_by(first_name: firstname, last_name: lastname,
                               birthdate: birthdate)
      if @camper
        session[:parent_id] = @camper.parent.id
        session[:parent] = @camper.parent.attributes
        session[:camper_id] = @camper.id
        session[:camper] = @camper.attributes
        msg = "Please make sure all of the information on the following pages "
        msg += "is up to date."
        flash[:info] = msg
        redirect_to next_wizard_path
      else
        @camper = Camper.new(first_name: firstname, last_name: lastname,
                             birthdate: birthdate)
        session[:camper] = @camper.attributes
        message = "This camper could not be found. "
        message += "Please check that all fields are correct; "
        message += "otherwise go back and start a new registration."
        flash[:danger] = message
        redirect_to wizard_path
      end
    when "parent"
      session[:parent] = {} if session[:parent].nil?
      session[:parent] = session[:parent].merge(parent_params(step).to_h)
      @parent = build_parent_from_session
      if @parent.valid?
        redirect_to wizard_path(next_step)
      else
        session[:form_has_errors] = true
        redirect_to wizard_path
      end
    when "referral"
      # refs = parent_params(step).to_h["referrals_attributes"].values
      # refs.reject!{ |r| r["_destroy"] == "1" }
      # session[:referrals] = refs
      session[:parent] = session[:parent].merge(parent_params(step).to_h)
      @parent = build_parent_from_session
      if @parent.valid?
        redirect_to next_wizard_path
      else
        session[:form_has_errors] = true
        redirect_to wizard_path
      end
    when "camper"
      session[:camper] = {} if session[:camper].nil?
      session[:camper] = session[:camper].merge(camper_params(step).to_h)
      @camper = build_camper_from_session
      if @camper.valid?
        redirect_to wizard_path(next_step)
      else
        session[:form_has_errors] = true
        redirect_to wizard_path
      end
    when "details"
      session[:reg] = reg_params(step).to_h
      @reg = build_reg_from_session
      if @reg.valid?
        redirect_to wizard_path(next_step)
      else
        session[:form_has_errors] = true
        redirect_to wizard_path
      end
    when "waiver"
      session[:reg] = session[:reg].merge(reg_params(step).to_h)
      @reg = build_reg_from_session
      if @reg.valid?
        redirect_to wizard_path(next_step)
      else
        session[:form_has_errors] = true
        redirect_to wizard_path
      end
    when "review"
      store_registration
      redirect_to wizard_path(next_step)
    when "siblings"
      sibling = params[:wizard][:sibling]
      case sibling
      when "new"
        redirect_to wizard_path(:camper)
      when "none"
        redirect_to wizard_path(next_step)
      else
        @camper = Parent.find(session[:parent_id]).campers.find(sibling)
        if @camper
          session[:camper_id] = sibling
          session[:camper] = Camper.find(sibling).attributes
          redirect_to wizard_path(:camper)
        else
          flash[:danger] = "That camper isn't registered under the same parent."
          redirect_to wizard_path
        end
      end
    when "payment"
      parent_id = session[:parent_id]
      @parent = parent_id ? Parent.find(parent_id) : Parent.new
      @parent.assign_attributes(session[:parent])
      @parent.transaction do
        campers = session[:campers]
        campers.each_with_index do |camper, i|
          reg_fields = session[:regs][i].merge(camp: Camp.first)
          c = camper["id"].nil? ? @parent.campers.build() : @parent.campers.find(camper["id"])
          c.assign_attributes(camper)
          c.registrations.build(reg_fields)
          c.save!
        end
        if @parent.save!
          clear_session
          redirect_to wizard_path(:submit)
        else
          flash[:danger] = "Something went wrong."
          redirect_to wizard_path
        end
      end
    end
  end

  private
    def parent_params(step)
      permitted_attrs = case step
        when "parent"
          [:first_name, :last_name, :email, :phone_number, :street, :city,
           :state, :zip]
        when "referral"
          [referrals_attributes: [:referral_method_id, :details, :_destroy]]
        end
      params.require(:parent).permit(permitted_attrs).merge(reg_step: step)
    end


    def camper_params(step)
      permitted_attrs = case step
        when "camper"
          [:first_name, :last_name, :gender, :birthdate, :email, :medical,
           :diet_allergies]
        end
      params.require(:camper).permit(permitted_attrs).merge(reg_step: step)
    end

    def reg_params(step)
      permitted_attrs = case step
        when "details"
          [:grade, :shirt_size, :bus]
        when "waiver"
          [:additional_notes, :waiver_signature, :waiver_date]
        end
      params.require(:registration).permit(permitted_attrs).merge(reg_step: step)
    end

    def form_has_errors?
      session[:form_has_errors]
    end

    def reset_errors
      session[:form_has_errors] = false
    end

    def build_parent_from_session
      parent = Parent.new(session[:parent])
      return parent
    end

    def initialize_referrals(parent)
      rm_ids = parent.referrals.collect{|r| r.referral_method_id}
      ReferralMethod.all.each do |rm|
        unless rm_ids.include?(rm.id)
          parent.referrals.build(referral_method_id: rm.id)
        end
      end
      return parent.referrals.sort_by &:referral_method_id
    end

    def build_camper_from_session
      # if returning camper, need to find existing record in db
      # otherwise camper uniqueness validation will think it's a duplicate
      # may want to change camper validations to allow duplicate name/bdays
      if session[:camper_id].nil?
        camper = Camper.new(session[:camper])
        camper.build_parent(session[:parent])
      else
        camper = Camper.find(session[:camper_id])
        camper.assign_attributes(session[:camper])
      end
      return camper
    end

    def build_reg_from_session
      camper = build_camper_from_session
      session[:reg] = {} if session[:reg].nil?
      reg = camper.registrations.build(session[:reg].merge(camp: Camp.first))
      return reg
    end

    def store_registration
      session[:campers] = [] if session[:campers].nil?
      session[:regs] = [] if session[:regs].nil?
      session[:campers] << session[:camper]
      session[:regs] << session[:reg]
      clear_current_camper
      clear_current_registration
    end

    def clear_parent
      session[:parent] = nil
      session[:parent_id] = nil
    end

    def clear_current_camper
      session[:camper_id] = nil
      session[:camper] = nil
    end

    def clear_all_campers
      session[:campers] = nil
      clear_current_camper
    end

    def clear_current_registration
      session[:reg] = nil
    end

    def clear_all_registrations
      session[:regs] = nil
      clear_current_registration
    end

    def clear_session
      clear_parent
      session[:referrals] = nil
      clear_all_campers
      clear_all_registrations
    end
end
