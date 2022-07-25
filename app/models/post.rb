class Post < ApplicationRecord
    belongs_to :user

def transform_post
    return {
        author: self.user.username,
        title: self.title,
        description: self.description,
        rating: self.rating,
        posted: self.created_at,
        editted: self.updated_at

    }
end

end
