import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "address",
    "zipCode",
    "city",
    "state",
    "country",
    "lat",
    "lng",
    "geocoder"
  ]

  static values = {
    "mapboxAccessToken": String
  }

  initialize() {
    this.initMapbox()
    // this.initNewMarker()
    this.addGeocoder()
  }

  initMapbox() {
    mapboxgl.accessToken = this.mapboxAccessTokenValue;

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [13.419506188839986, 52.4942909415001],
      zoom: 10,
    });
  }

  // initNewMarker() {
  //   this.marker = new mapboxgl.Marker({
  //     draggable: true
  //   })
  //   .setLngLat([13.419506188839986, 52.4942909415001])
  //   .addTo(this.map);

  //   this.marker.on('dragend', () => this.onDragEnd())
  // }

  addMarker(lat, lng) {
    this.marker = new mapboxgl.Marker({
      draggable: true
    })
    .setLngLat([lng, lat])
    .addTo(this.map);

    this.marker.on('dragend', () => this.onDragEnd())
  }

  addGeocoder() {
    this.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
    })

    this.geocoder.on('result', () => this.onGeocoderResult())

    this.geocoderTarget.appendChild(this.geocoder.onAdd(this.map));
  }

  onDragEnd() {
    const lngLat = this.marker.getLngLat(); 

    console.log(this.marker)

    this.latTarget.value = lngLat.lat;
    this.lngTarget.value = lngLat.lng;
  }

  onGeocoderResult() {
    console.log(this.geocoder)
    console.log(this.geocoder.lastSelected)
    console.log(this.geocoder.lastSelected["center"])
    console.log(JSON.parse(this.geocoder.lastSelected))
    console.log(JSON.parse(this.geocoder.lastSelected)["center"])
  }

  searchByAddress() {
    if (this.addressLine1Target) {
      this.forwardGeocode(this.addressLine1Target)
    }
  }
}