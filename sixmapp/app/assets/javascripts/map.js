var map;
var marker = null;

function initialize() {

var mapOptions = {
    zoom: 10,
    disableDefaultUI: false,
    center: new google.maps.LatLng(40.806695741,-73.963952064), 
    mapTypeId: google.maps.MapTypeId.ROADMAP
};

map = new google.maps.Map(document.getElementById('map'), mapOptions);


google.maps.event.addListener(map, 'click', function(event) {
//call function to create marker

    $("#coordinate").val(event.latLng.lat() + ", " + event.latLng.lng());
    $("#coordinate").select();

    document.getElementById('latitude').value = event.latLng.lat();
    document.getElementById('longitude').value = event.latLng.lng();
    //delete the old marker
    if (marker) { marker.setMap(null); }

    marker = new google.maps.Marker({ position: event.latLng, map: map});

});

}  

google.maps.event.addDomListener(window, 'load', initialize);

