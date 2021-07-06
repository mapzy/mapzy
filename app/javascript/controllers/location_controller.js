import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "addressLine1",
    "zipCode",
    "city",
    "state",
    "country",
    "lat",
    "lng",
  ]

  static values = {
    "mapboxAccessToken": String
  }

  initialize() {
    this.initMapbox()
  }

  initMapbox() {
    mapboxgl.accessToken = this.mapboxAccessTokenValue;

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
    });

    this.marker = new mapboxgl.Marker({
      draggable: true
    }).setLngLat([0, 0])
      .addTo(this.map);

    this.marker.on('dragend', () => this.onDragEnd())
  }

  onDragEnd() {
    const lngLat = this.marker.getLngLat(); 

    this.latTarget.value = lngLat.lat;
    this.lngTarget.value = lngLat.lng;
  }
}