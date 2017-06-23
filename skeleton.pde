import java.nio.FloatBuffer;
/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/

 KinectPV2, Kinect for Windows v2 library for processing

 Skeleton depth tracking example
 */

import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;


int[] line = new int[4];
IntList lines;

KinectPV2 kinect;

float multiplyX = 3.5;
float multiplyY = 2;

HashMap<KSkeleton, Point[]> skeletonJoints;

Point lefty;

float leftyX;
float leftyY;

Point righty;

float rightyX;
float rightyY;

Point head;

float headX;
float headY;

boolean drawing = false;

ArrayList<Grid> grid = new ArrayList();
ArrayList<Point> allPoints = new ArrayList();

//grid stuff
int gap = 4;
int dotSize = 2;
int roundedx;
int roundedy;
int gridSpring = 10; //lower number is strong

PImage logo;
int activePixel;
float redChannel = 0;


void setup() {
  size(1920, 1080);
  logo = loadImage("logo.jpg");
  image(logo, 0, 0);
  
  
  skeletonJoints = new HashMap<KSkeleton, Point[]>();
  
  //gravity = new ArrayList<Point>();
  kinect = new KinectPV2(this);
  
  makeTable();

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(false);
  kinect.enableSkeletonDepthMap(true);

  kinect.init();
  
  gridSize(gap);
  
  for (int i = 0; i < roundedx+1; i++) {
    for (int j = 0; j < roundedy+1; j++) {
      if (red(logo.get(gap * i,gap * j)) > 50) grid.add(new Grid(gap*i, gap*j, dotSize, gridSpring));
    }
  }
  
  //drawing the hands, hard coded, for now.
}

void draw() {
  background(0);
  rect(50,0, 50, height);
  fill(255,0,0);
  rect(width-50, 0, 50, height);
  fill(255,0,0);
  image(kinect.getDepthMaskImage(), 0, 0);
  //println(grid.get(100).findX);
  //image(logo, 0, 0);
  //activePixel = logo.get(mouseX, mouseY);
  //redChannel = red(activePixel);
  //println(red(logo.get(mouseX,mouseY)));
  
  //image(kinect.getDepthMaskImage(), 0, 0);
  
  //get the skeletons as an Arraylist of KSkeletons
  
  
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
  //println(skeletonArray.size() + " skeletons detected and " + skeletonArray.size() * 3 + " gravity joints rendered");
  
  if(skeletonArray.size() < skeletonJoints.size())
  {
    print("Imbalance : ");
    for(KSkeleton skelly : skeletonJoints.keySet())
    {
      if(!skeletonArray.contains(skelly))
      {
        println("Deleting Joints");
        skeletonJoints.remove(skelly);
        break;
      }
    }
  }
  else if(skeletonArray.size() > skeletonJoints.size())
  {
    for(KSkeleton skelly : skeletonArray)
    {
      if(!skeletonJoints.containsKey(skelly))
      {
        println("Creating joints!");
        Point[] pointarr = new Point[] { new Point(new PVector(width/4, height/4), 20, 10000), new Point(new PVector(width/4, height/4), 20, 10000), new Point(new PVector(width/4, height/4), 20, 10000) };
        skeletonJoints.put(skelly, pointarr);
        break;
      }
    }
  }
  //individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
  //for (int i = 0; i < 1; i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    //if the skeleton is being tracked compute the skleton joints
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //color col  = skeleton.getIndexColor();
      //fill(col);
      //stroke(col);

      drawBody(joints);
      Point[] points = skeletonJoints.get(skeleton);
      if(points != null)
      {
        for(Point x : points) {
          if(x != null)
          {
            x.killZone();
            int indexOf = java.util.Arrays.asList(points).indexOf(x);
            switch(indexOf)
            {
              case 0 :
              {
                drawHandState(joints[KinectPV2.JointType_HandRight], x);
                break;
              }
              case 1 :
              {
                drawHandState(joints[KinectPV2.JointType_HandLeft], x);
                break;
              }
              case 2 :
              {
                drawHandState(joints[KinectPV2.JointType_Head], x);
                break;
              }
            }
          }
        }
      }
      
      //if(drawing)
      //{
      //  line[0] = (int)joints[KinectPV2.JointType_HandRight].getX();
      //  line[1] = (int)joints[KinectPV2.JointType_HandRight].getY();
      //  addToLines();
      //  line[2] = (int)joints[KinectPV2.JointType_HandRight].getX();
      //  line[3] = (int)joints[KinectPV2.JointType_HandRight].getY();
      //  stroke(255);
      //}
      //drawLines();
    }
  }
  
  for (Grid gridItem : grid) {
    gridItem.applyGravity();
    gridItem.keepShape();
    gridItem.display();
  }
  
  if(grid.get(10).findX < 0)
  {
    setup();
    println("Called");
  }
  
  fill(255, 0, 0);
  text(frameRate, 50, 50);
  fill(0);
  
  
}

void drawLines()
{
  for(int i = 0; i < lines.size(); i++)
  {
    if(i % 4 == 3 && i != 0)
    {
      line(lines.get(i-3), lines.get(i-2), lines.get(i-1), lines.get(i));
    }
  }
}

void addToLines()
{
  for(int i = 0; i < line.length; i++)
  {
    lines.append(line[i]);
  }
}

//draw the body
void drawBody(KJoint[] joints) {
  //drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_SpineShoulder);
  //drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineBase);
  //drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  //drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);

  //// Right Arm
  //drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  //drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_HandRight);

  //// Left Arm
  //drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  //drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_HandLeft);

  /*// Right Leg
  drawBone(joints, KinectPV2.JointType_Spine_Base, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_FootLeft);*/

  //Single joints
  drawJoint(joints, KinectPV2.JointType_Head);
  //drawJoint(joints, KinectPV2.JointType_HandLeft);
  //drawJoint(joints, KinectPV2.JointType_HandRight);
}

Table tracker;
String[] stringarr = new String[18];

void makeTable() {
  tracker = new Table();
  stringarr = new String[] { "headX", "headY", "spineShoulderX", "spineShoulderY", "spineBaseX", "spineBaseY", "shoulderRightX", "shoulderRightY", "shoulderLeftX", "shoulderLeftY", "elbowRightX", "elbowRightY", "handRightX", "handRightY", "elbowLeftX", "elbowLeftY", "handLeftX", "handLeftY" };
  tracker.addColumn("headX");
  tracker.addColumn("headY");
  tracker.addColumn("spineShoulderX");
  tracker.addColumn("spineShoulderY");
  tracker.addColumn("spineBaseX");
  tracker.addColumn("spineBaseY");
  tracker.addColumn("shoulderRightX");
  tracker.addColumn("shoulderRightY");
  tracker.addColumn("shoulderLeftX");
  tracker.addColumn("shoulderLeftY");
  tracker.addColumn("elbowRightX");
  tracker.addColumn("elbowRightY");
  tracker.addColumn("handRightX");
  tracker.addColumn("handRightY");
  tracker.addColumn("elbowLeftX");
  tracker.addColumn("elbowLeftY");
  tracker.addColumn("handLeftX");
  tracker.addColumn("handLeftY");
}


public int last = 0;
public int arrayCounter = 0;
//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX()*multiplyX, joints[jointType].getY()*multiplyY);
  //if(arrayCounter == 18)
  //{
  //  last++;
  //  arrayCounter = 0;
  //}
  //tracker.addRow();
  //tracker.setFloat(last, stringarr[arrayCounter], joints[jointType].getX());
  //arrayCounter++;
  //tracker.setFloat(last, stringarr[arrayCounter], joints[jointType].getY());
  //arrayCounter++;
  ////println(joints[jointType].getX());
  ////println(joints[jointType].getY());
  ellipse(0, 0, 25, 25);
  fill(0, 255, 0);
  popMatrix();
}

//draw a bone from two joints, not using
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX()*multiplyX, joints[jointType1].getY()*multiplyY);
  //ellipse(0, 0, 25, 25);
  //fill(0,0,0);
  popMatrix();
  line(joints[jointType1].getX()*multiplyX, joints[jointType1].getY()*multiplyY, joints[jointType2].getX()*multiplyX, joints[jointType2].getY()*multiplyY);
}

//draw a ellipse depending on the hand state
void drawHandState(KJoint joint, Point object)
{
  noStroke();
  handState(joint.getState(), object);
  pushMatrix();
  translate(joint.getX()*multiplyX, joint.getY()*multiplyY);
  ellipse(0, 0, 70, 70);
  fill(0,0,255);
  object.newPos(joint.getX()*multiplyX, joint.getY() * multiplyY);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */

//Depending on the hand state change the color
void handState(int handState, Point obj) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(255, 0, 0);
    //obj.changeMass(5000);
    //drawing = false;
    break;
  case KinectPV2.HandState_Closed:
    //fill(0, 0, 0);
    //obj.changeMass(10000);
    //drawing = true;
    //ellipse(5, 5, 5, 5);
    //saveTable(tracker, "data/coords.csv");
    //println("Table saved at " + hour() + ":" + minute() + ":" + second() + ".");
    break;
  case KinectPV2.HandState_Lasso:
    //fill(0, 0, 0);
    break;
  case KinectPV2.HandState_NotTracked:
    //fill(0, 0, 0);
    break;
  }
}

void gridSize(int e) {
  float xCount = width/e;
  roundedx = Math.round(xCount);
  float yCount = height/e;
  roundedy = Math.round(yCount);
}
