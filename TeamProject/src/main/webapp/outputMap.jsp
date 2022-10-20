<%@page import="java.util.List"%>
<%@page import="membership.UploadDTO"%>
<%@page import="membership.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel = "stylesheet" href="resource/css/NewFile.css">
<link rel="stylesheet" type="text/css" href="css/map.css" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="menu.jsp" />
<!-- 지도를 표시할 div 입니다 -->
<div id="map" style="width:100%;height:94%;"></div>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=def47418c26c1b2e8383afc08b8370c5&libraries=services,drawing,clusterer"></script>

<%
String list= request.getAttribute("UploadDTO").toString();
System.out.println(list);
%>
<jsp:include page="InfoWindowStyle.jsp"></jsp:include>
<script>
var list = <%=request.getAttribute("UploadDTO")%>

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
var map = new kakao.maps.Map(mapContainer, mapOption);

//마커 클러스터러를 생성합니다 
var clusterer = new kakao.maps.MarkerClusterer({
    map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
    averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
    minLevel: 5 // 클러스터 할 최소 지도 레벨 
});

// 데이터를 가져오기 위해 jQuery를 사용합니다
// 데이터를 가져와 마커를 생성하고 클러스터러 객체에 넘겨줍니다

/* $.get(list, function(data) {
    // 데이터에서 좌표 값을 가지고 마커를 표시합니다
    // 마커 클러스터러로 관리할 마커 객체는 생성할 때 지도 객체를 설정하지 않습니다
    
    var markers = $(data.positions).map(function(i, position) {
        return new kakao.maps.Marker({
            position : new kakao.maps.LatLng(position.lat, position.lng)
        });
    });
    
    // 클러스터러에 마커들을 추가합니다
    clusterer.addMarkers(markers);
}); */

//HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
if (navigator.geolocation) {
    
    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
    navigator.geolocation.getCurrentPosition(function(position) {
        
        var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도
        
        var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
            message = '<div style="padding:5px;">현재 위치</div>'; // 인포윈도우에 표시될 내용입니다
        
        // 마커와 인포윈도우를 표시합니다
        displayMarker(locPosition, message);
            
      });
    
} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
    
    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
        message = 'geolocation을 사용할수 없어요..'
        
    displayMarker(locPosition, message);
}

// 지도에 마커와 인포윈도우를 표시하는 함수입니다
function displayMarker(locPosition, message) {

    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({  
        map: map, 
        position: locPosition
    }); 
    
    var iwContent = message, // 인포윈도우에 표시할 내용
        iwRemoveable = true;

    // 인포윈도우를 생성합니다
    var infowindow = new kakao.maps.InfoWindow({
        content : iwContent,
        removable : iwRemoveable
    });
    
    // 인포윈도우를 마커위에 표시합니다 
    infowindow.open(map, marker);
    
    // 지도 중심좌표를 접속위치로 변경합니다
    map.setCenter(locPosition);      
}    


// 마커 이미지의 이미지 주소입니다
var imageSrc = "image/abcd3.png"; 

function reportChk(el) { // 신고 알림
	var cnt = list[el].count;
	console.log(el);
	console.log(cnt);
	if(cnt>3) alert("신고가 누적되어 삭제되었습니다.");
	else alert("신고가 완료되었습니다.");
}

function deleteData() { // 업로드데이터삭제
	alert("삭제가 완료되었습니다.");
}

//마커들을 저장할 변수 생성(마커 클러스터러 관련)
var markers = [];

 for (var i =0; i < list.length; i++) {    
    // 마커 이미지의 이미지 크기 입니다
    var imageSize = new kakao.maps.Size(35, 49); 
    
    // 마커 이미지를 생성합니다    
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
    
    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({        
    	map: map, // 마커를 표시할 지도        
        position: new kakao.maps.LatLng(list[i].lat, list[i].lng), // 마커를 표시할 위치        
        //title : list[i].memo, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
        image : markerImage, // 마커 이미지      	 
        clickable: true // 마커를 클릭했을 때 지도의 클릭 이벤트가 발생하지 않도록 설정합니다
    });	


    // 생성된 마커를 마커 저장하는 변수에 넣음(마커 클러스터러 관련)
    markers.push(marker);
    
    
    
    // 마커에 표시할 인포윈도우를 생성합니다     
    
    var text = [];
	for(var j =0; j<i; j++){
		if(list[i].lat == list[j].lat && list[i].lng == list[j].lng ) text.push("<a class =\"btn btn-danger btn-sm\" href=\"Map.map?num="+
				list[j].num+"&&id="+list[j].id+"&&count="+list[j].count+"\"onclick=\"reportChk("+j+");\">신고</a>" +
				"<b>"+list[j].memo+"</b>"+list[j].date+
				"<a class =\"btn btn-primary btn-sm\" href=\"Map.map?num="+list[j].num+"\" onclick=\"deleteData();\">삭제</a>") ; 
	}	
	
	var infowindow = new kakao.maps.InfoWindow({
        content:  "<a class =\"btn btn-danger btn-sm\" href=\"Map.map?num="+list[i].num+"&&id="+list[i].id+
        		"&&count="+list[i].count+"\" onclick=\"reportChk("+j+");\">신고</a>" +
        	"<span class=\"info-title\" Style=\"text-align: center;\"><b>"+list[i].title+"</b><b>"+list[i].memo+"</b>" +list[i].date +
        	"<a class =\"btn btn-primary btn-sm\" href=\"Map.map?num="+list[i].num+"\" onclick=\"deleteData();\">삭제</a>" + text.reverse().join("")+"</span>",
        //map:map,
        removable : true
        
    });
	
    // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
    // 이벤트 리스너로는 클로저를 만들어 등록합니다 
    // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
    
    kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow) 

    );
    kakao.maps.event.addListener(marker, 'click', makeOutListener(infowindow));
  }  
 
//클러스터러에 마커들을 추가합니다(마커 클러스터러 관련)
 clusterer.addMarkers(markers);
 
 function setStyleOfElement(el, elStyle){
	 for(var prop of Object.keys(elStyle)){        		 
		 el.style[prop.toString()] = elStyle[prop.toString()];        		 
	 }
 }
//인포윈도우를 표시하는 클로저를 만드는 함수입니다 
  function makeOverListener(map, marker, infowindow) {
     return function() {    	    	
         infowindow.open(map, marker); // html 에서 스타일이 이미 적용된 엘리먼트를 추가를 해버림         
         document.querySelectorAll('.info-title').forEach(function (item){  
        	 
        	 console.log(item.children[0])
        	 
        	  setStyleOfElement(item.parentElement, infoWindowStyle)
        	 //setStyleOfElement(item.children[0], infoSpanStyle)
        	  //setStyleOfElement(item, infoBoxStyle)
        	 
        	 setStyleOfElement(item.parentElement.parentElement, infoContainerStyle)
         })
     };
 } 
 
 // 인포윈도우를 닫는 클로저를 만드는 함수입니다 
 function makeOutListener(infowindow) {
     return function() {
         //infowindow.setMap(null);
    	 infowindow.close();
     };
 }

</script>

</body>
</html>