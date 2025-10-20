Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_payload do |controller|
    {
      user_id: controller.respond_to?(:current_user) && controller.current_user&.id,
      request_id: controller.request.uuid,
      ip: controller.request.remote_ip
    }
  end
end
