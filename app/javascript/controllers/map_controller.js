import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "locationView"
  ]
  static values = {
    "mapboxAccessToken" : String,
    "markers": Object,
    "bounds": Array,
    "locationBaseUrl": String
  }

  initialize() {
    this.initMapbox();
    this.fitToMarkers();

  }

  isMobile() {
    return window.innerWidth <= 768;
  }

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

      anchor.href = `${this.locationBaseUrlValue}/${feature.properties.hashid}`;
      anchor.setAttribute("data-turbo-frame", "locations_show");
      anchor.setAttribute("data-action", "map#showLocationView");

      let marker = new mapboxgl.Marker({
        color: "#E74D67",
        anchor: "bottom"
      });

      anchor.appendChild(marker.getElement())

      anchor.addEventListener('click', this.moveMapOnHiddenMarker.bind(this));

      new mapboxgl.Marker({ 
        element: anchor,
        // offset is necessary because we are using a custom element
        offset: [-12, -35]
      })
        .setLngLat(feature.geometry.coordinates)
        .addTo(this.map);
    }

    // add zoom buttons
    if (!this.isMobile()) {
      var nav = new mapboxgl.NavigationControl();
      this.map.addControl(nav, "bottom-right");
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

    // add geolocation button
    if (this.isMobile()) {
      this.map.addControl(this.geolocate, "top-right");
    } else {
      this.map.addControl(this.geolocate, "bottom-right");
    }
    

    if (!this.isMobile()) {
      // add search bar
      this.map.addControl(
        new MapboxGeocoder({
          accessToken: mapboxgl.accessToken,
          mapboxgl: mapboxgl,
          collapsed: false,
          marker: false,
          zoom: 15,
        }),
        "top-right"
      );
    }
    }

  moveMapOnHiddenMarker(event) {
    const minX = 460;
    const panelHeight = (window.innerHeight / 2);
    if (!this.isMobile() && event.x < minX) {
      this.map.panBy([event.x - minX, 0]);
    } else if (this.isMobile() && event.y > panelHeight * 0.9) {
      this.map.panBy([0, event.y - panelHeight + 35]);
    }
  }
}
