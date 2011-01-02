<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetAddress.aspx.cs" Inherits="SetAddress" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
		<title>Google Maps Spike</title>
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
  html { height: 100% }
  body { height: 100%; margin: 0px; padding: 0px }
  #map_canvas { height: 100% }
</style>
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false">
</script>
	<script type="text/javascript">
		var geocoder;
		var map;

		function initialize() {
			var latlng = new google.maps.LatLng(-34.397, 150.644);
			var myOptions = {
				zoom: 15,
				center: latlng,
				mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
			geocoder = new google.maps.Geocoder
		}

			function showAddress() {
				var address = document.getElementById("<%=txtAddress.ClientID %>").value;
				geocoder.geocode({ 'address': address }, function (results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						map.setCenter(results[0].geometry.location);
						var marker = new google.maps.Marker({
							map: map,
							position: results[0].geometry.location,
							title: address
						});
						var infowindow = new google.maps.InfoWindow({
							content: address
						});
						google.maps.event.addListener(marker, 'click', function () {
							infowindow.open(map, marker);
						});
					} else {
						alert("Geocode was not successful for the following reason: " + status);
					}
				});
			}


	</script>
</head>
<body onload="initialize()" >
	<form id="form1" runat="server" >
	<div>
		<div>
			<asp:TextBox ID="txtAddress" runat="server" value="3911 hartzdale dr camp hill pa 17011"/>
			<input type="button" value="Find" onclick="showAddress();" />
		</div>

		<div id="map_canvas" style="width: 500px; height: 500px"></div>
	</div>
	</form>
</body>
</html>

