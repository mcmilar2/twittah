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
		logo_image = "logo.png"
		image_tag("#{logo_image}", :alt => "Logo Banner", :class => "round")
	end

end
