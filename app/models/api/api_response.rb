class ApiResponse
    attr_accessor :success, :message, :data  
    def initialize(success, message, data)
      @success = success
      @message = message
      @data = data
    end
    def to_json
      {
        success: success,
        message: message,
        data: data
      }.to_json
  end
end
  