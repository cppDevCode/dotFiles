from fastapi import FastAPI

app = FastAPI(title="Bahia Blanca Weather API")

@app.get("/weather/current")
def get_current_weather():
    """Devuelve el clima actual en Bahía Blanca."""
    return {
        "city": "Bahía Blanca",
        "country": "Argentina",
        "temperature": 15.0,
        "condition": "Nublado",
        "humidity": 65
    }

@app.get("/weather/forecast")
def get_weather_forecast():
    """Devuelve un pronóstico a corto plazo para Bahía Blanca."""
    return {
        "city": "Bahía Blanca",
        "country": "Argentina",
        "forecast": [
            {"day": "Mañana", "temperature": 18.0, "condition": "Soleado"},
            {"day": "Pasado mañana", "temperature": 20.0, "condition": "Despejado"}
        ]
    }

if __name__ == "__main__":
    import uvicorn
    # Para ejecutar de manera standalone si es necesario (útil al debugear)
    uvicorn.run(app, host="127.0.0.1", port=8099)
