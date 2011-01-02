<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DrivingDirections.aspx.cs" Inherits="DrivingDirections" %>

<html>
<head>
<title>Google Map Spike</title>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
  html { height: 100% }
  body { height: 100%; margin: 0px; padding: 0px }
  #map_canvas { height: 100% }
</style>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript">
	var directionsDisplay;
	var directionsService = new google.maps.DirectionsService();
	var map;
	var oldDirections = [];
	var currentDirections = null;

	function initialize() {
		var myOptions = {
			zoom: 7,
			center: new google.maps.LatLng(40.21238, -76.943975),
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

		directionsDisplay = new google.maps.DirectionsRenderer({
			'map': map,
			'preserveViewport': true,
			'draggable': true
		});
		directionsDisplay.setPanel(document.getElementById("directions_panel"));

		google.maps.event.addListener(directionsDisplay, 'directions_changed',
	  function () {
		  if (currentDirections) {
			  oldDirections.push(currentDirections);
			  setUndoDisabled(false);
		  }
		  currentDirections = directionsDisplay.getDirections();
	  });

		setUndoDisabled(true);

		calcRoute();
	}

	function calcRoute() {
		var start = document.getElementById("txtStart").value;
		var end = document.getElementById("txtEnd").value;
		var request = {
			origin: start,
			destination: end,
			travelMode: google.maps.DirectionsTravelMode.DRIVING
		};
		directionsService.route(request, function (response, status) {
			if (status == google.maps.DirectionsStatus.OK) {
				directionsDisplay.setDirections(response);
				
			}
		});
	}

	function undo() {
		currentDirections = null;
		directionsDisplay.setDirections(oldDirections.pop());
		if (!oldDirections.length) {
			setUndoDisabled(true);
		}
	}

	function setUndoDisabled(value) {
		document.getElementById("undo").disabled = value;
	}
</script>
</head>
<body onload="initialize()">
<div>
			<input id="txtStart" type="text" value="3911 hartzdale dr camp hill pa 17011"/>
			<input id="txtEnd" type="text" value="Times Square, 7th Avenue, New York, NY"/>
			
			<input type="button" value="Find" onclick="calcRoute();" />
		</div>
<div id="map_canvas" style="float:left;width:70%;height:90%"></div>
<div style="float:right;width:30%;height:90%;overflow:auto">
  <button id="undo" style="display:block;margin:auto" onclick="undo()">Undo
  </button>
  <div id="directions_panel" style="width:100%"></div>
</div>

</body>
</html>
