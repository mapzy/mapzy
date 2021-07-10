import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "address",
    "zipCode",
    "city",
    "country",
    "lat",
    "lng",
  ]

  static values = {
    "mapboxAccessToken": String
  }

  get fullAddress() {
    const zipCodeCity = [this.zipCodeTarget.value, this.cityTarget.value].join(' ')
    return [this.addressTarget.value, zipCodeCity, this.countryTarget.value].join(',');
  }

  isReadyToGeocode() {
    return (
      this.addressTarget.value &&
      this.zipCodeTarget.value &&
      this.cityTarget.value &&
      this.countryTarget.value
    )
  }

  initialize() {
    this.initMapbox();
    this.initMapboxSdk();
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

  initMapboxSdk() {
    this.mapboxClient = mapboxSdk({ accessToken: this.mapboxAccessTokenValue });
  }

  addMarker(center) {
    this.marker = new mapboxgl.Marker({
      draggable: true
    })
    .setLngLat(center)
    .addTo(this.map);

    this.marker.on('dragend', () => this.onDragEnd());
  }

  onDragEnd() {
    const lngLat = this.marker.getLngLat(); 

    this.latTarget.value = lngLat.lat;
    this.lngTarget.value = lngLat.lng;
  }

  forwardGeocode() {
    if (this.isReadyToGeocode()) {
      setTimeout(() => {
        const query = this.fullAddress;

        this.mapboxClient.geocoding
          .forwardGeocode({
            query: query,
            autocomplete: false,
            limit: 1
          })
          .send()
          .then((response) => {
            if (
              response &&
              response.body &&
              response.body.features &&
              response.body.features.length
            ) {
                const feature = response.body.features[0];

                this.addMarker(feature.center);

                this.map.flyTo({
                  center: feature.center,
                  zoom: 13,
                  bearing: 0,
                  essential: true
                })

            }
          });

      }, 3000)
    }
  }
}