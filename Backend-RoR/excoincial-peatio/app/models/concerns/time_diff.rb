module TimeDiff
  extend ActiveSupport::Concern

  def time_cal(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs

	  hours = seconds_diff / 3600
	  seconds_diff -= hours * 3600

	  minutes = seconds_diff / 60
	  seconds_diff -= minutes * 60

	  if hours >= 1
  		"#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}" + " " + "hours ago"
  	else
  		"#{minutes.to_s.rjust(2, '0')}" + " " + "minutes ago"
  	end
  end
end