class User < ApplicationRecord
    has_one_attached :image

    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password,
                length: { minimum: 6 },
                if: -> { new_record? || !password.nil? }
    
    def image_url
        Rails.application.routes.url_helpers.url_for(image) if image.attached?
    end
end
