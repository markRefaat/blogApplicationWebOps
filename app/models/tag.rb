class Tag < ApplicationRecord
    belongs_to :post, optional: true
end
