class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title
	validates :description, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true, presence: true
	validates :image_url, format: {
		with: %r{\.(gif|jpg|png)$}i,
		message: 'must be a URL for GIF, JPG or PNG image.'
	}
	# validates :price, format: {
	# 	with: %r{\d*\.\d\d\z},
	# 	message: 'must be a valid dollar amount.'
	# }
	has_many :line_items
	has_many :orders, through: :line_items
	before_destroy :ensure_not_referenced_by_any_line_item
	
	private
		# ensure that there are no line items referencing this product
		def ensure_not_referenced_by_any_line_item
		  if line_items.empty?
		    return true
		  else
		    errors.add(:base, 'Line Items present')
		    return false
		  end
		end
end
