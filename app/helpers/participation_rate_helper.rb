module ParticipationRateHelper
	def participation_rate_image(participation_rate)
		logo_base = "#{Rails.configuration.logos_domain}/images/participation_rates/"
		participation_rate ||= 0

    participation_rate = participation_rate.to_i

		if(participation_rate > 97)
			logo_name = '100.png'
		elsif(participation_rate > 92)
			logo_name = '95.png'
		elsif(participation_rate > 87)
			logo_name = '90.png'
		elsif(participation_rate > 82)
			logo_name = '85.png'
		elsif(participation_rate > 77)
			logo_name = '80.png'
		elsif(participation_rate > 72)
			logo_name = '75.png'
		elsif(participation_rate > 67)
			logo_name = '70.png'
		elsif(participation_rate > 62)
			logo_name = '65.png'
		elsif(participation_rate > 57)
			logo_name = '60.png'
		elsif(participation_rate > 52)
			logo_name = '55.png'
		elsif(participation_rate > 47)
			logo_name = '50.png'
		elsif(participation_rate > 42)
			logo_name = '45.png'
		elsif(participation_rate > 37)
			logo_name = '40.png'
		elsif(participation_rate > 32)
			logo_name = '35.png'
		elsif(participation_rate > 27)
			logo_name = '30.png'
		elsif(participation_rate > 22)
			logo_name = '25.png'
		elsif(participation_rate > 17)
			logo_name = '20.png'
		elsif(participation_rate > 12)
			logo_name = '15.png'
		elsif(participation_rate > 7)
			logo_name = '10.png'
		elsif(participation_rate > 2)
			logo_name = '5.png'
		else
			logo_name = '0.png'
		end

		return logo_base + logo_name
	end
end
