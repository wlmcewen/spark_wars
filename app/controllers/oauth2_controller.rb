class Oauth2Controller < ApplicationController
  
  skip_before_filter :authenticate

  def callback
    SparkApi.activate(:default)
    provider = SparkApi.client.oauth2_provider
    code = params.fetch(:code) {  raise MissingOAuthCode, "Unhandled user missing auth code." }
    session[:spark_id] = spark_id = "user_code_#{code}"
    if find_session.nil?
      provider.code = code
      provider.initialize_session spark_id
      begin
        SparkApi.client.authenticate
      rescue Faraday::Error::ConnectionFailed => e
        render :json => SparkApi.client.inspect
        return
      end
    end
    redirect_to params.fetch(:state, root_path), :spark_id => spark_id
    
    # /oauth2?client_id=e0zwx26q97h0yo5yyrlqx7a4h
    # &response_type=code
    #&redirect_uri=http%3A%2F%2Flocalhost.sparkplatform.com%3A3000%2Foauth2%2Fcallback%3Fstate%3D%2F
    # redirect to the proper place
  end
  
  protected
  
  def process_code()
  end
  
end
