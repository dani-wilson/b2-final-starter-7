class HolidayService
  def get_holidays
    response = HTTParty.get('https://date.nager.at/api/v3/PublicHolidays/2023/US')
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end