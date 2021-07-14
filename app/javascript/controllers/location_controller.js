import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "address",
    "zipCode",
    "city",
    "country",
    "latitude",
    "longitude",
    "adjustMarkerLink",
    "adjustMarkerBlock",
  ]

  static values = {
    "mapboxAccessToken": String,
    "typingTimer": Number,
    "typingInterval": Number,
  }

  get fullAddress() {
    const zipCodeCity = [this.zipCodeTarget.value, this.cityTarget.value].join(' ')
    return [this.addressTarget.value, zipCodeCity, this.countryTarget.value].join(',');
  }

  initialize() {
    this.initMapbox();
    this.initMapboxSdk();
    this.initMarker();
    this.showAdjustMarkerLink();

    this.typingIntervalValue = 1000;
  }

  initMapbox() {
    mapboxgl.accessToken = this.mapboxAccessTokenValue;

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [13.419506188839986, 52.4942909415001],
      zoom: 12,
    });
  }

  initMapboxSdk() {
    this.mapboxClient = mapboxSdk({ accessToken: this.mapboxAccessTokenValue });
  }

  initMarker() {
    this.marker = new mapboxgl.Marker({
      draggable: true
    });

    this.marker.on('dragend', () => this.onDragEnd());

    if (this.latitudeTarget.value && this.longitudeTarget.value) {
      this.moveMarker([this.longitudeTarget.value, this.latitudeTarget.value])
    }
  }

  moveMarker(center) {
    this.marker.setLngLat(center);
    this.marker.addTo(this.map);
    this.moveMapTo(center);
  }

  moveMapTo(center) {
    this.map.flyTo({
      center: center,
      zoom: 15,
      bearing: 0,
      essential: true
    });
  }

  onDragEnd() {
    const lngLat = this.marker.getLngLat(); 

    this.latitudeTarget.value = lngLat.lat;
    this.longitudeTarget.value = lngLat.lng;
  }

  isReadyToGeocode() {
    return (
      this.addressTarget.value &&
      this.zipCodeTarget.value &&
      this.cityTarget.value &&
      this.countryTarget.value
    )
  }

  // Wait until the user has (probably) finished typing the address fields
  searchByAddress() {
    clearTimeout(this.typingTimerValue);
    if (this.isReadyToGeocode()) {
      this.typingTimerValue = setTimeout(() => this.forwardGeocode(), this.typingIntervalValue);
    }
  }

  forwardGeocode() {
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

        this.moveMarker(feature.center);

        this.longitudeTarget.value = feature.center[0];
        this.latitudeTarget.value = feature.center[1];

        this.showAdjustMarkerLink();
      }
    });
  }

  zoomOnMarker() {
    if (this.marker) {
      this.map.flyTo({
        center: this.marker.getLngLat(),
        zoom: 20,
        bearing: 0,
        essential: true
      })
    }
  }

  showAdjustMarkerLink() {
    if (this.latitudeTarget.value && this.longitudeTarget.value && !this.adjustMarkerBlockHidden()) {
      this.adjustMarkerLinkTarget.classList.remove("hidden");
    }
  }

  showAdjustMarkerBlock() {
    this.adjustMarkerLinkTarget.classList.add("hidden");
    this.adjustMarkerBlockTarget.classList.remove("hidden");
  }

  adjustMarkerBlockHidden() {
    this.adjustMarkerBlockTarget.classList.contains("hidden");
  }
}