import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    "mapboxAccessToken" : String,
    "markers": Object,
    "bounds": Array,
    "locationBaseUrl": String,
    "dashboard": Boolean,
    "paramNoAccidentalZoom": Boolean,
    "customColor": String,
    "customAccentColor": String,
    "locale": String
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
          language: this.localeValue
        }),
        "top-right"
      );
    }
  }

  createMarkers() {
    this.markerAnchors = [];

    for (var feature of this.markersValue.features) {
      const locationId = feature.properties.hashid;
      const anchor = document.createElement("a");

      anchor.href = `${this.locationBaseUrlValue}/${locationId}?language=${this.localeValue}`;

      anchor.setAttribute("data-turbo-frame", "side_panel");
      anchor.setAttribute("data-action", "side-panel#showPanel");
      anchor.setAttribute("data-location-id", locationId);

      const marker = new mapboxgl.Marker({
        color: this.customColorValue,
        anchor: "bottom"
      });

      const markerElement = marker.getElement();

      anchor.appendChild(markerElement);
      anchor.addEventListener("click", this.moveMapOnHiddenMarker.bind(this));
      anchor.addEventListener("mouseenter", () => this.toggleHighlightMarker(markerElement));
      anchor.addEventListener("mouseleave", () => this.toggleHighlightMarker(markerElement));

      this.markerAnchors.push(anchor);

      new mapboxgl.Marker({ 
        element: anchor,
        // offset is necessary because we are using a custom element
        offset: [-12, -35]
      })
        .setLngLat(feature.geometry.coordinates)
        .addTo(this.map);
    }
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

  findMarker(locationId) {
    return this.markerAnchors.find(marker => marker.getAttribute("data-location-id") === locationId);
  }

  toggleHighlightMarker(markerElement, customColor, customAccentColor) {
    const svg = markerElement.firstChild;
    const path = svg.querySelector('path');
    const currentColor = path.getAttribute('fill');

    path.setAttribute('fill', currentColor === this.customColorValue ? this.customAccentColorValue : this.customColorValue);
  }
}
