from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_get_current_weather():
    response = client.get("/weather/current")
    assert response.status_code == 200
    data = response.json()
    assert data["city"] == "Bahía Blanca"
    assert "temperature" in data
    assert data["condition"] == "Nublado"

def test_get_weather_forecast():
    response = client.get("/weather/forecast")
    assert response.status_code == 200
    data = response.json()
    assert data["city"] == "Bahía Blanca"
    assert "forecast" in data
    assert len(data["forecast"]) == 2
    assert data["forecast"][0]["day"] == "Mañana"
