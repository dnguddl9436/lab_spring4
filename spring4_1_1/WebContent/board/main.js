// Initialize and add the map
function initMap() {
  // The map, centered
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 16,
  });

  //infoWindow 초기화
  let infoWindow = new google.maps.InfoWindow();

  //Marker 초기화
  let marker = new google.maps.Marker({ map: map });

  //Marker 말풍선만들기
  const errand_regist = document.createElement("span");
  errand_regist.textContent = "What do you want!!??";
  errand_regist.classList.add("errand_regist");

  navigator.geolocation.getCurrentPosition(onSuccessGeolocation);

  function onSuccessGeolocation(position) {
    //메인 페이지 로드시, 내 위치 바로 맵에 띄워줌.
    let myPosition = new google.maps.LatLng(
      position.coords.latitude,
      position.coords.longitude
    );
    console.log(position.coords.latitude + ", " + position.coords.longitude);
    map.setCenter(myPosition);
    marker.setPosition(myPosition);
    infoWindow.setContent(errand_regist);
    infoWindow.open(map, marker);

    //마커 클릭시 이벤트
    marker.addListener("click", () => {
      map.setZoom(15);
      infoWindow.setContent(errand_regist);
      infoWindow.open(map, marker);
      map.setCenter(marker.getPosition());
    });
  }

  /* =======================[[ 동일 위도, 경도 집합체 표시 ]]========================= */
  // Create an array of alphabetical characters used to label the markers.
  const labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  // Add some markers to the map.
  // Note: The code uses the JavaScript Array.prototype.map() method to
  // create an array of markers based on a given "locations" array.
  // The map() method here has nothing to do with the Google Maps API.
  const markers = locations.map((location, i) => {
    return new google.maps.Marker({
      position: location,
      label: labels[i % labels.length],
    });
  });

  // Add a marker clusterer to manage the markers.
  new MarkerClusterer(map, markers, {
    imagePath:
      "https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m",
  });

  /* =======================[[ 내위치 가져오기 ]]========================= */

  // [내 위치 가져오기] 버튼
  const locationButton = document.createElement("button");
  locationButton.textContent = "Click here get my position";
  locationButton.classList.add("custom-map-control-button");
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(locationButton);

  // [내위치 버튼] 클릭시 이벤트
  locationButton.addEventListener("click", () => {
    // Try HTML5 geolocation.
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };

          marker.setPosition(pos);
          infoWindow.setContent(errand_regist);
          infoWindow.open(map, marker);
          map.setCenter(pos);
        },
        () => {
          handleLocationError(true, infoWindow, map.getCenter());
        }
      );
    } else {
      // Browser doesn't support Geolocation
      handleLocationError(false, infoWindow, map.getCenter());
    }
  });

  function handleLocationError(browserHasGeolocation, infoWindow, pos) {
    infoWindow.setPosition(pos);
    infoWindow.setContent(
      browserHasGeolocation
        ? "Error: The Geolocation service failed."
        : "Error: Your browser doesn't support geolocation."
    );
    infoWindow.open(map);
  }
}

/* MarkerClusterer 위치 */
const locations = [
  { lat: 37.53, lng: 126.988 },
  { lat: 37.53, lng: 126.988 },
  { lat: 37.54, lng: 126.97 },
  { lat: 37.54, lng: 126.97 },
  { lat: 37.523, lng: 126.95 },
  { lat: 37.523, lng: 126.95 },
  { lat: 37.545, lng: 126.886 },
  { lat: 37.545, lng: 126.886 },
  { lat: 37.545, lng: 126.886 },
  { lat: 37.533, lng: 126.77 },
  { lat: 37.533, lng: 126.77 },
  { lat: 37.52, lng: 126.955 },
  { lat: 37.52, lng: 126.955 },
  { lat: 37.52, lng: 126.955 },
];
