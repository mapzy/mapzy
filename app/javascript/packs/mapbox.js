document.addEventListener('turbolinks:load', function(event) { 

  // get access token
  mapboxgl.accessToken = document.getElementById('map').getAttribute("data-mapbox-access-token");

  console.log("dddd");

  var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/mapbox/streets-v11',
  center: [12.550343, 55.665957],
  zoom: 8
  });
   
  // Create a default Marker and add it to the map.
  var marker1 = new mapboxgl.Marker()
  .setLngLat([12.554729, 55.70651])
  .addTo(map);
   
  // Create a default Marker, colored black, rotated 45 degrees.
  var marker2 = new mapboxgl.Marker({ color: 'black', rotation: 45 })
  .setLngLat([12.65147, 55.608166])
  .addTo(map);
});