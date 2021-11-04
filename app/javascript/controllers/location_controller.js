import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "addressWrapper",
    "addressError",
    "latitude",
    "longitude",
    "adjustMarkerLink",
    "adjustMarkerBlock",
  ]

  static values = {
    "mapboxAccessToken": String,
    "typingTimer": Number,
    "typingInterval": Number,
    "bounds": Array,
    "address": String,
  }

  get adjustMarkerBlockHidden() {
    return this.adjustMarkerBlockTarget.classList.contains("hidden");
  }

  initialize() {
    this.initMapbox();
    this.initMarker();
    this.initGeocoder();
    this.prepareAddressInput();
    this.handleAdjustMarkerLink();
  }

  initMapbox() {
    mapboxgl.accessToken = this.mapboxAccessTokenValue;

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      bounds: this.boundsValue,
      fitBoundsOptions: {
        maxZoom: 12,
      },
    });
  }

  initGeocoder() {
    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      types:'address',
      placeholder: 'Start typing...'
    });

    geocoder.addTo(this.addressWrapperTarget);

    // When geocoder result is selected by user
    geocoder.on('result', (e) => {
      this.addressErrorTarget.textContent = '';
      this.moveMarker(e.result.center);
      this.updateLngLat(e.result.center[0], e.result.center[1]);
      this.handleAdjustMarkerLink();
    });

    // When geocoder is cleared
    geocoder.on('clear', () => {
      this.clearLngLat();
      this.clearMarker();
    });
  }

  prepareAddressInput() {
    this.addressInput = this.addressWrapperTarget.firstChild.getElementsByTagName('input')[0];

    // Add form attributes
    this.addressInput.setAttribute("id", "location_address");
    this.addressInput.setAttribute("name", "location[address]");

    // Add value if exists
    if (this.addressValue) {
      this.addressInput.value = this.addressValue;
    }

    // Make it required
    this.addressInput.required = true;

    // Turn off autocomplete
    this.addressInput.autocomplete = "off";

    // Suit up bro
    this.addressInput.classList.add('input--default')
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

  onDragEnd() {
    const lngLat = this.marker.getLngLat();
    this.updateLngLat(lngLat.lng, lngLat.lat);
  }

  updateLngLat(lng, lat) {
    this.longitudeTarget.value = lng;
    this.latitudeTarget.value = lat;
  }

  clearLngLat() {
    this.longitudeTarget.value = "";
    this.latitudeTarget.value = "";
  }

  moveMarker(center) {
    this.marker.setLngLat(center);
    this.marker.addTo(this.map);
    this.moveMapTo(center);
  }

  clearMarker() {
    this.marker.remove();
  }

  moveMapTo(center) {
    this.map.flyTo({
      center: center,
      zoom: 15,
      bearing: 5
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

  handleAdjustMarkerLink() {
    if (this.latitudeTarget.value && this.longitudeTarget.value && this.adjustMarkerBlockHidden) {
      this.showAdjustMarkerLink();
    } else {
      this.hideAdjustMarkerLink();
    }
  }

  hideAdjustMarkerLink() {
    this.adjustMarkerLinkTarget.classList.add("hidden");
  }

  showAdjustMarkerLink() {
    this.adjustMarkerLinkTarget.classList.remove("hidden");
  }

  showAdjustMarkerBlock() {
    this.adjustMarkerBlockTarget.classList.remove("hidden");
    this.handleAdjustMarkerLink();
  }

  validateAddress(e) {
    const valid = !!this.addressInput.value && !!this.latitudeTarget.value && !!this.longitudeTarget.value

    if (!valid) {
      this.addressErrorTarget.textContent = "Please make sure that the address is valid"
      e.preventDefault();
      return false;
    }
  }
}