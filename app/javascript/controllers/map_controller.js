import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "sidePanel"
  ]
  static values = {
    "mapboxAccessToken" : String,
    "markers": Object,
    "bounds": Array,
    "locationBaseUrl": String,
    "dashboard": Boolean,
    "paramNoAccidentalZoom": Boolean
  }

  initialize() {
    mapboxgl.accessToken = this.mapboxAccessTokenValue;

    this.map = new mapboxgl.Map({
      container: "map",
      style: "mapbox://styles/mapbox/streets-v11",
      cooperativeGestures: !this.dashboardValue && this.paramNoAccidentalZoomValue,
      bounds: this.boundsValue,
      fitBoundsOptions: { padding: 50, maxZoom: 12 },
      logoPosition: "top-left"
    });

    // create markers
    this.createMarkers();

    // add zoom buttons
    this.addZoomButtons();

    // Add geolocate control to the map.
    this.addGeolocateButton();

    // Add search bar to the map
    this.addSearchBar();
  }

  addGeolocateButton() {
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
  }

  addZoomButtons() {
    if (!this.isMobile()) {
      var nav = new mapboxgl.NavigationControl();
      this.map.addControl(nav, "bottom-right");
    }
  }

  addSearchBar() {
    if (!this.isMobile()) {
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

  createMarkers() {
    for (var feature of this.markersValue.features) {
      let anchor = document.createElement("a");

      anchor.href = `${this.locationBaseUrlValue}/${feature.properties.hashid}`;
      anchor.setAttribute("data-turbo-frame", "locations_show");
      anchor.setAttribute("data-action", "map#showSidePanel");

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
  }

  hideSidePanel() {
    this.sidePanelTarget.classList.add("hidden");
  }

  showSidePanel() {
    this.sidePanelTarget.classList.remove("hidden");
  }

  isMobile() {
    return window.innerWidth <= 768;
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
