module ApplicationHelper
	
	# Return a title on a per-page basis
	def title
		base_title = "twittah!"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
	def logo
		logo_image = "images/logo.png"
		'<img src='#{logo_image}' alt='Logo' />'
	end

end
