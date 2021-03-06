class Admin::SmsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required

  layout "admin"
  
  def index
    params[:filter] ||= "unread"
    @sms_messages = Api::Sms.find(:all, :conditions => {:state => params[:filter]})
    respond_to do |format|
      format.html
      format.json{ render :json => @sms_messages }
    end
  end

  def new
    @sms_message = Api::Sms.new
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
  
  def show
    @sms_message = Api::Sms.find(params[:id])
  end

  def create
    @sms_message = Api::Sms.new(params[:api_sms])
    if @sms_message.save
      @sms_message.deliver!
      flash[:notice] = "Successfully created SMS message."
      redirect_to admin_sms_path
    else
      flash[:warning] = "Could not save SMS message."
      render :action => "new"
    end
  end

end
