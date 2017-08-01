class WebhookController < ActionController::Base

  def webhook
    user = request.env[:resolved_resource]
    puts user.first_name
    user.products.each do |product|
      puts product.uid
    end
  end

end
