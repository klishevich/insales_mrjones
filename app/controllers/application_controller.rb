# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authentication, :configure_api

  protected

  def authentication
    logout if enter_from_different_shop?
    # Rails.logger.info('start authentication log')
    # Rails.logger.info('api_key')
    # Rails.logger.info(Figaro.env.insales_api_key)
    # Rails.logger.info('api_secret')
    # Rails.logger.info(Figaro.env.insales_api_secret)
    # Rails.logger.info('api_autologin_url')
    # Rails.logger.info(Figaro.env.insales_api_autologin_url)

    if (current_app and current_app.authorized?) or (Rails.env == "development")
    # if true
      # Rails.logger.info('if current_app and current_app.authorized?')
      # acc = Account.find_by(insales_subdomain: current_app.shop)
      # Rails.logger.info('acc')
      # Rails.logger.info(acc.insales_subdomain) if acc
      if (Rails.env == "development")
        return if @account = Account.find_by(insales_subdomain: 'menje.myinsales.ru')
      else
        return if @account = Account.find_by(insales_subdomain: current_app.shop)
      end
        # return if @account = Account.find_by(insales_subdomain: 'busation.myinsales.ru')
    end

    store_location

    if account_by_params
      # Rails.logger.info('account_by_params')
      init_authorization account_by_params
    else
      # Rails.logger.info('no account_by_params')
      redirect_to login_path
    end
  end

  def logout
    reset_session
  end

  def configure_api
    current_app.configure_api
  end

  def init_authorization account
    session[:app] = MyApp.new(account.insales_subdomain, account.password)

    redirect_to session[:app].authorization_url
  end

  def store_location(path = nil)
    session[:return_to] = path || request.fullpath
  end

  def location
    session[:return_to]
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def enter_from_different_shop?
    current_app and !params[:shop].blank? && params[:shop] != current_app.shop
  end

  def account_by_params
    @account ||= if params[:insales_id]
      Account.find_by insales_id: params[:insales_id]
    else
      Account.find_by insales_subdomain: params[:shop]
    end
  end

  def current_app
    session[:app]
  end
end
