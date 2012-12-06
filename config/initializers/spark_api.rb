# Add a to_json function for Fixnum, ActiveSupport doesn't yet have this apparently
# via => http://prettystatemachine.blogspot.com/2010/09/typeerrors-in-tojson-make-me-briefly.html
class Fixnum
  def to_json(options = nil)
    to_s
  end
end

# Overwrite the client's connection class.  
module SparkApi
  def self.logger
    if @logger.nil?
      @logger = Rails.logger 
    end 
    @logger
  end 
end

