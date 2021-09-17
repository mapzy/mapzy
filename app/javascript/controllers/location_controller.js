import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "address",
    "geocoder",
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
    "bounds": Array,
  }

  get adjustMarkerBlockHidden() {
    return this.adjustMarkerBlockTarget.classList.contains("hidden");
  }

  initialize() {
    this.initMapbox();
    this.initMarker();
    this.initGeocoder();
    this.handleAdjustMarkerLink();
  }

  initMapbox() {
    mapboxgl.accessToken = this.mapboxAccessTokenValue;

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      bounds: this.boundsValue,
    });

    this.mapboxClient = mapboxSdk({ accessToken: this.mapboxAccessTokenValue });
  }

  initGeocoder() {
    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken
    });

    geocoder.addTo(this.geocoderTarget);

    // When geocoder result is selected by user
    geocoder.on('result', (e) => {
      console.log(JSON.stringify(e.result, null, 2));

      this.moveMarker(e.result.center);
      this.updateLngLat(e.result.center[0], e.result.center[1]);
      this.handleAdjustMarkerLink();
    });

    // When geocoder is cleared
    geocoder.on('clear', () => {
      //
    });
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

  moveMarker(center) {
    this.marker.setLngLat(center);
    this.marker.addTo(this.map);
    this.moveMapTo(center);
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

  // get fullAddress() {
  //   const zipCodeCity = [this.zipCodeTarget.value, this.cityTarget.value].join(' ')
  //   return [this.addressTarget.value, zipCodeCity, this.countryTarget.value].join(',');
  // }

  // isReadyToGeocode() {
  //   return (
  //     this.addressTarget.value &&
  //     this.zipCodeTarget.value &&
  //     this.cityTarget.value &&
  //     this.countryTarget.value
  //   )
  // }

  // Wait until the user has (probably) finished typing the address fields
  // searchByAddress() {
  //   clearTimeout(this.typingTimerValue);
  //   if (this.isReadyToGeocode()) {
  //     this.typingTimerValue = setTimeout(() => this.forwardGeocode(), this.typingIntervalValue);
  //   }
  // }

  // forwardGeocode() {
  //   const query = this.fullAddress;

  //   this.mapboxClient.geocoding
  //   .forwardGeocode({
  //     query: query,
  //     autocomplete: false,
  //     limit: 1
  //   })
  //   .send()
  //   .then((response) => {
  //     if (
  //       response &&
  //       response.body &&
  //       response.body.features &&
  //       response.body.features.length
  //     ) {
  //       const feature = response.body.features[0];

  //       this.moveMarker(feature.center);
  //       updateLngLat(feature.center[0], feature.center[1]);

  //       if (this.adjustMarkerBlockHidden) {
  //         this.showAdjustMarkerLink();
  //       }
  //     }
  //   });
  // }

}