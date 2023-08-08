class HolidayService
  def self.get_holidays
    response = HTTParty.get('https://date.nager.at/api/v3/NextPublicHolidays/US')
    parsed = JSON.parse(response.body, symbolize_names: true)
    parsed[0..2]
  end
end