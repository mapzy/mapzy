import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "locationView"
  ]
  static values = {
    "mapboxAccessToken" : String,
    "markers": Object,
    "bounds": Array,
    "locationBaseUrl": String,
    "askLocationPermission": Boolean,
  }

  initialize() {
    this.initMapbox();
    this.fitToMarkers();

  }

  // requestPermission() {
  //   // request location permission from browser
  //   this.geolocate.trigger();
  // }

  showLocationView() {
    this.locationViewTarget.classList.remove("hidden");
  }

  hideLocationView() {
    this.locationViewTarget.classList.add("hidden");
  }

  fitToMarkers() {
    this.map.fitBounds(this.boundsValue, {padding: 50, maxZoom: 12});
   }

  initMapbox() {
    // get access token
    mapboxgl.accessToken = this.mapboxAccessTokenValue;
    
    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
    });

    // create markers
    for (var feature of this.markersValue.features) {
      let anchor = document.createElement('a');

      anchor.href = `${this.locationBaseUrlValue}/${feature.properties.id}`;
      anchor.setAttribute("data-turbo-frame", "locations_show");
      anchor.setAttribute("data-action", "map#showLocationView");

      let marker = new mapboxgl.Marker({
        color: "#E74D67",
        anchor: "bottom"
      });

      anchor.appendChild(marker.getElement())

      new mapboxgl.Marker({ 
        element: anchor,
        // offset is necessary because we are using a custom element
        offset: [-12, -35]
      })
        .setLngLat(feature.geometry.coordinates)
        .addTo(this.map);
    }

    // Add geolocate control to the map.
    this.geolocate = new mapboxgl.GeolocateControl({
      positionOptions: {
        enableHighAccuracy: true
      },
      trackUserLocation: false,
      fitBoundsOptions: {
        maxZoom: 12,
      },
    });

    this.map.addControl(this.geolocate);

    // add zoom buttons
    var nav = new mapboxgl.NavigationControl();
    this.map.addControl(nav, "bottom-right");

    this.map.addControl(
      new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        mapboxgl: mapboxgl,
        collapsed: false,
        marker: false,
        zoom: 15,
      })
     );
  }
}
