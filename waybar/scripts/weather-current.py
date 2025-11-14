#!/usr/bin/env python3
import json
import urllib.request
import urllib.error

CITY_CODE = "Uberlandia,Brazil"
CITY_NAME = "Uberlândia, Brazil"

def get_weather():
    try:
        url = f"http://wttr.in/{CITY_CODE}?format=j1"
        with urllib.request.urlopen(url, timeout=5) as response:
            return json.loads(response.read().decode())
    except (urllib.error.URLError, urllib.error.HTTPError, Exception):
        return None

def get_weather_icon(code):
    code = str(code)
    icons = {
        "113": "☀️", "116": "⛅", "119": "☁️", "122": "☁️", "143": "🌫️",
        "176": "🌦️", "179": "🌨️", "182": "🌧️", "185": "🌧️", "200": "⛈️",
        "227": "🌨️", "230": "❄️", "248": "🌫️", "260": "🌫️", "263": "🌦️",
        "266": "🌧️", "281": "🌧️", "284": "🌧️", "293": "🌦️", "296": "🌧️",
        "299": "🌧️", "302": "🌧️", "305": "🌧️", "308": "🌧️", "311": "🌧️",
        "314": "🌧️", "317": "🌨️", "320": "🌨️", "323": "🌨️", "326": "🌨️",
        "329": "🌨️", "332": "🌨️", "335": "❄️", "338": "❄️", "350": "🌧️",
        "353": "🌦️", "356": "🌧️", "359": "🌧️", "362": "🌨️", "365": "🌨️",
        "368": "🌨️", "371": "❄️", "374": "🌧️", "377": "🌧️", "386": "⛈️",
        "389": "⛈️", "392": "⛈️", "395": "⛈️"
    }
    return icons.get(code, "🌡️")

def main():
    data = get_weather()
    
    if not data:
        print(json.dumps({"text": ""}))
        return

    current = data.get("current_condition", [{}])[0]
    weather = data.get("weather", [{}])[0]
    
    temp_c = current.get("temp_C", "?")
    feels_like = current.get("FeelsLikeC", "?")
    desc = current.get("weatherDesc", [{}])[0].get("value", "Unknown")
    humidity = current.get("humidity", "?")
    wind_speed = current.get("windspeedKmph", "?")
    wind_dir = current.get("winddir16Point", "?")
    pressure = current.get("pressure", "?")
    visibility = current.get("visibility", "?")
    uv_index = current.get("uvIndex", "?")
    
    min_temp = weather.get("mintempC", "?")
    max_temp = weather.get("maxtempC", "?")
    sunrise = weather.get("astronomy", [{}])[0].get("sunrise", "?")
    sunset = weather.get("astronomy", [{}])[0].get("sunset", "?")
    
    weather_code = current.get("weatherCode", "113")
    icon = get_weather_icon(weather_code)
    
    text = f"{icon} {temp_c}°"
    
    forecast_days = data.get("weather", [])[1:4]
    forecast_lines = []

    days = ["Tomorrow", "Day 2", "Day 3"]
    for i, day in enumerate(forecast_days):
        day_desc = day.get("hourly", [{}])[4].get("weatherDesc", [{}])[0].get("value", "?")
        day_min = day.get("mintempC", "?")
        day_max = day.get("maxtempC", "?")
        day_code = day.get("hourly", [{}])[4].get("weatherCode", "113")
        day_icon = get_weather_icon(day_code)
        forecast_lines.append(f"  {days[i]}: {day_icon} {day_min}°-{day_max}° {day_desc}")

    forecast_text = "\n".join(forecast_lines) if forecast_lines else ""

    tooltip = f"""🌍 {CITY_NAME}

{desc}

🌡️  Temperature: {temp_c}°C (feels like {feels_like}°C)
📊 Today's Range: {min_temp}°C - {max_temp}°C
💧 Humidity: {humidity}%
💨 Wind: {wind_speed} km/h {wind_dir}
🔽 Pressure: {pressure} mb
👁️  Visibility: {visibility} km
☀️  UV Index: {uv_index}

🌅 Sunrise: {sunrise}
🌇 Sunset: {sunset}

📅 3-Day Forecast:
{forecast_text}"""
    
    output = {"text": text, "tooltip": tooltip}
    print(json.dumps(output))

if __name__ == "__main__":
    main()
