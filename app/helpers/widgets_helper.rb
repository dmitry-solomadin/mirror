module WidgetsHelper

  def time_zone_options
    ActiveSupport::TimeZone.all.map do |time_zone|
      utc_offset = ActiveSupport::TimeZone.seconds_to_utc_offset(time_zone.utc_offset)
      time_zone_name = ActiveSupport::TimeZone::MAPPING[time_zone.name]

      ["(GMT#{utc_offset}) #{time_zone_name}", time_zone_name]
    end
  end

  def directions_mode_list
    [['driving', 'google.maps.TravelMode.DRIVING'], ['bicycling', 'google.maps.TravelMode.BICYCLING'],
     ['transit', 'google.maps.TravelMode.TRANSIT'], ['walking', 'google.maps.TravelMode.WALKING']]
  end

end
