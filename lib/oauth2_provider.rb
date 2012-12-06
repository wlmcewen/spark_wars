class OAuth2Provider < SparkApi::Authentication::BaseOAuth2Provider
  class MissingOAuthCode < ::StandardError; end
  class MissingOAuthAccessToken < ::StandardError; end

  attr_accessor :user_key, :cached_session
  attr_reader :authorization_uri, :access_uri, :redirect_uri

  def initialize(credentials)
    @authorization_uri = credentials[:authorization_uri]
    @access_uri        = credentials[:access_uri]
    @redirect_uri      = credentials[:redirect_uri]
    @client_id         = credentials[:client_id]
    @client_secret     = credentials[:client_secret]
    @user_key           = nil
    @cached_session    = nil
  end

  def redirect(url)
    raise MissingOAuthCode, "Unhandled user missing auth code.  Need to redirect them to #{url}"
  end
  

  def load_session()
    if @user_key.nil?
      return nil
    end
    cached = Rails.cache.read cache_key
    Rails.logger.debug("Returning '#{cached.inspect}' for load_session()")
    cached
  end
  
  def initialize_session(key)
    @user_key = key
    load_session()
  end

  def save_session(session)
    raise MissingOAuthAccessToken, "The session access token is missing: #{session.inspect}" if (session.access_token.nil? || session.access_token.empty?)
    Rails.logger.debug("[sso-cache] Write oauth session for '#{cache_key}'")
    Rails.cache.write cache_key, session
  end

  protected 

  def cache_key
    "oauth2_sessions/#{user_key}"    
  end
  
end
