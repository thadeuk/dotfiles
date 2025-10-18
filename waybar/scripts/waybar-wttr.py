#!/usr/bin/env python3
import json
import urllib.request
import urllib.error

CITIES = [
    {"name": "Chiang Mai", "code": "ChiangMai,Thailand"},
    {"name": "Rouen", "code": "Rouen,France"}
]

def get_weather(city_code):
    try:
        url = f"http://wttr.in/{city_code}?format=j1"
        with urllib.request.urlopen(url, timeout=5) as response:
            return json.loads(response.read().decode())
    except (urllib.error.URLError, urllib.error.HTTPError, Exception):
        return None

def format_weather(data):
    if not data:
        return None

    current = data.get("current_condition", [{}])[0]
    temp_c = current.get("temp_C", "?")
    feels_like = current.get("FeelsLikeC", "?")
    desc = current.get("weatherDesc", [{}])[0].get("value", "Unknown")
    humidity = current.get("humidity", "?")

    weather_code = current.get("weatherCode", "113")
    icon = get_weather_icon(weather_code)

    return {
        "temp": temp_c,
        "feels": feels_like,
        "desc": desc,
        "humidity": humidity,
        "icon": icon
    }

def get_weather_icon(code):
    code = str(code)
    icons = {
        "113": "☀️",  # Clear/Sunny
        "116": "⛅",  # Partly cloudy
        "119": "☁️",  # Cloudy
        "122": "☁️",  # Overcast
        "143": "🌫️",  # Mist
        "176": "🌦️",  # Patchy rain possible
        "179": "🌨️",  # Patchy snow possible
        "182": "🌧️",  # Patchy sleet possible
        "185": "🌧️",  # Patchy freezing drizzle
        "200": "⛈️",  # Thundery outbreaks
        "227": "🌨️",  # Blowing snow
        "230": "❄️",  # Blizzard
        "248": "🌫️",  # Fog
        "260": "🌫️",  # Freezing fog
        "263": "🌦️",  # Patchy light drizzle
        "266": "🌧️",  # Light drizzle
        "281": "🌧️",  # Freezing drizzle
        "284": "🌧️",  # Heavy freezing drizzle
        "293": "🌦️",  # Patchy light rain
        "296": "🌧️",  # Light rain
        "299": "🌧️",  # Moderate rain at times
        "302": "🌧️",  # Moderate rain
        "305": "🌧️",  # Heavy rain at times
        "308": "🌧️",  # Heavy rain
        "311": "🌧️",  # Light freezing rain
        "314": "🌧️",  # Moderate or heavy freezing rain
        "317": "🌨️",  # Light sleet
        "320": "🌨️",  # Moderate or heavy sleet
        "323": "🌨️",  # Patchy light snow
        "326": "🌨️",  # Light snow
        "329": "🌨️",  # Patchy moderate snow
        "332": "🌨️",  # Moderate snow
        "335": "❄️",  # Patchy heavy snow
        "338": "❄️",  # Heavy snow
        "350": "🌧️",  # Ice pellets
        "353": "🌦️",  # Light rain shower
        "356": "🌧️",  # Moderate or heavy rain shower
        "359": "🌧️",  # Torrential rain shower
        "362": "🌨️",  # Light sleet showers
        "365": "🌨️",  # Moderate or heavy sleet showers
        "368": "🌨️",  # Light snow showers
        "371": "❄️",  # Moderate or heavy snow showers
        "374": "🌧️",  # Light showers of ice pellets
        "377": "🌧️",  # Moderate or heavy showers of ice pellets
        "386": "⛈️",  # Patchy light rain with thunder
        "389": "⛈️",  # Moderate or heavy rain with thunder
        "392": "⛈️",  # Patchy light snow with thunder
        "395": "⛈️",  # Moderate or heavy snow with thunder
    }
    return icons.get(code, "🌡️")

def main():
    weather_data = []

    for city in CITIES:
        data = get_weather(city["code"])
        weather = format_weather(data)
        if weather:
            weather_data.append({
                "name": city["name"],
                **weather
            })

    if not weather_data:
        output = {"text": ""}
    else:
        text_parts = []
        tooltip_lines = []

        for w in weather_data:
            text_parts.append(f"{w['icon']} {w['temp']}°")
            tooltip_lines.append(
                f"{w['name']}: {w['desc']}\n"
                f"Temperature: {w['temp']}°C (feels like {w['feels']}°C)\n"
                f"Humidity: {w['humidity']}%"
            )

        output = {
            "text": " | ".join(text_parts),
            "tooltip": "\n\n".join(tooltip_lines)
        }

    print(json.dumps(output))

if __name__ == "__main__":
    main()
