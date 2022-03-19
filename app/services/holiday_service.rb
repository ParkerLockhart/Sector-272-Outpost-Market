class HolidayService

  def next_holidays
    response = Faraday.get("https://date.nager.at/api/v2/NextPublicHolidays/us")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end

end
