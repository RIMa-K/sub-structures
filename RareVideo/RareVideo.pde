
/**********************************************************************************
 
 _ _ _ _ _
 yttrium
 ^ ^ ^ ^ ^
 
 Code to playback a fragmented and distorted video clip, depicted a collection of 
 artifacts related to RareEarths. The playback jumps to different points throughout 
 the clips duration, in reference to stock data from sales of RareEarths over the past
 10 years. 
 
 Using processing video library...
 mapping...
 arrays...
 audio?
 
 **********************************************************************************/


import processing.video.*;

Movie myMovie;

int vol;


int time;

//Array to store selected data from table
float dataUse [];

void setup() {

  fullScreen();
  background(0);
  frameRate(30);

  myMovie = new Movie(this, "Rare Earth Mining.mp4");
  //specify mode to play movie
  myMovie.loop();

  //load data using the Table class
  //load data table
  final Table Molycorp = loadTable("Molycorp.csv", "header");

  //find out how may rows of data there is and store the vol variable.
  final int vol = Molycorp.getRowCount();

  //a for loop to iterate through the file.
  for (int i=0; i< Molycorp.getRowCount(); i = i + 1) {

    //select the row corresponding to the counter(i).
    TableRow row = Molycorp.getRow(i);

    //look at the volume column
    int data = row.getInt("volume");

    //scale the orginal values to the 
    float dataScaled = map(data, 0, 8200000, 0, (myMovie.duration()));

    float dataReady = constrain(dataScaled, 0, 3000);
    //change floats to ints
    int dataGo = (int) dataReady;

    //Instantiate an arrays to store the data
    final float[] dataUse = new float[vol];


    dataUse[0] =  dataGo;

    println (dataGo);
    //println (myMovie.duration());
  }
}
//FROM HERE ON NOTHING WORKS! 
void draw() {

  image(myMovie, 0, 0);//keep

//fiX!
  for (int j=0; j< myMovie.duration(); j++) {
    if (millis()>time) {
      time=millis()+3000;

      myMovie.jump(dataUse[j]);
      //read next value in array?


    
      // myMovie.jump(random( 0, (myMovie.duration())));
    }
  }
}
/* This function is run when a new frame is available.
 Use this function for process the image data separately from drawing 
 (and as quickly as possible.) You cannot draw to the screen inside the
 movieEvent() function. If you want to draw immediately based on the 
 new image,then use the Movie.available() method. 
 */
void movieEvent(Movie m) {
  //use read() method to capture the new frame.
  m.read();

  //float mt = myMovie.time();
  //float md = myMovie.duration();
} 