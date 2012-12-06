require 'oauth2_provider'
require 'cgi/session'
class ApplicationController < ActionController::Base
  include SparkApi::Models
  
  before_filter :authenticate
  
  rescue_from OAuth2Provider::MissingOAuthCode, :with => :reauthenticate

  
  def authenticate
    find_session || reauthenticate
  end

  def find_session
    SparkApi.activate(:default)
    key = lookup_key || return
    SparkApi.client.oauth2_provider.initialize_session key
  end
  
  def lookup_key
    return nil unless session.loaded?
#    session.load! unless session.loaded?
    ssid = session[:spark_id] || return 
    Rails.logger.debug "user_key = #{ssid}"
    ssid
  end
  
  def reauthenticate
    redirect_uri = "https://#{full_host}/oauth2/callback"
    SparkApi.client.oauth2_provider.redirect_uri = redirect_uri
    redirect_to SparkApi.client.authenticator.authorization_url
  end
  
  # Fix the dumb port on local developments
  def full_host
    if(request.host =~ /^localhost/ && request.port != 80)
      "#{request.host}:#{request.port}"
    else
      request.host
    end
  end
  
  protect_from_forgery
end
