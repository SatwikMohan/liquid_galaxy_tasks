import 'package:flutter_lg_task2/look_at_entity.dart';

class BalloonMakers{
  static String balloon(LookAtEntity lookAtEntity){
    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>Task2</name>
 <Style id="weather_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
        <h1>City Name: Dhanbad</h1>
        <h2>Satwik Mohan</h2>
     </text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="ww">
   <description>
   </description>
   <LookAt>
     <longitude>${lookAtEntity.lng}</longitude>
     <latitude>${lookAtEntity.lat}</latitude>
     <heading>${lookAtEntity.heading}</heading>
     <tilt>${lookAtEntity.tilt}</tilt>
     <range>${lookAtEntity.range}</range>
   </LookAt>
   <styleUrl>#weather_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${lookAtEntity.lng},${lookAtEntity.lat},0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';
  }

  static blankBalloon(LookAtEntity lookAtEntity) => '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>RightLGBalloon</name>
 <Style id="balloon">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
        <h1>City Name: Dhanbad</h1>
        <h2>Satwik Mohan</h2>
     </text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="bb">
   <description>
   </description>
   <styleUrl>#balloon</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${lookAtEntity.lng},${lookAtEntity.lat},0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';

}