class Post < ApplicationRecord
    belongs_to :user
    has_one_attached :image
    validates_presence_of :description

def transform_post
    return {
        user_id: self.user_id,
        author: self.user.username,
        title: self.title,
        description: self.description,
        rating: self.rating,
        posted: self.created_at,
        editted: self.updated_at, 
        image: self.image_url
    }
end

def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
end

end
