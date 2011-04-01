module ParticipationRateHelper
	def participation_rate_image(participation_rate)
		logo_base = "#{Rails.configuration.logos_domain}/images/participation_rates/"
		participation_rate ||= 0

    participation_rate = participation_rate.to_i

		if(participation_rate >= 100)
			logo_name = '100.png'
		elsif(participation_rate >= 95)
			logo_name = '95.png'
		elsif(participation_rate >= 90)
			logo_name = '90.png'
		elsif(participation_rate >= 85)
			logo_name = '85.png'
		elsif(participation_rate >= 80)
			logo_name = '80.png'
		elsif(participation_rate >= 75)
			logo_name = '75.png'
		elsif(participation_rate >= 70)
			logo_name = '70.png'
		elsif(participation_rate >= 65)
			logo_name = '65.png'
		elsif(participation_rate >= 60)
			logo_name = '60.png'
		elsif(participation_rate >= 55)
			logo_name = '55.png'
		elsif(participation_rate >= 50)
			logo_name = '50.png'
		elsif(participation_rate >= 45)
			logo_name = '45.png'
		elsif(participation_rate >= 40)
			logo_name = '40.png'
		elsif(participation_rate >= 35)
			logo_name = '35.png'
		elsif(participation_rate >= 30)
			logo_name = '30.png'
		elsif(participation_rate >= 25)
			logo_name = '25.png'
		elsif(participation_rate >= 20)
			logo_name = '20.png'
		elsif(participation_rate >= 15)
			logo_name = '15.png'
		elsif(participation_rate >= 10)
			logo_name = '10.png'
		elsif(participation_rate >= 5)
			logo_name = '5.png'
		else
			logo_name = '0.png'
		end

		return logo_base + logo_name
	end
end
