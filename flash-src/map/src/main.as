/*
 * Author: Nathan Batson
 * Copyright (c) ScullyTown.com 2009
 * Version: 0.0.1
 */

package
{
  import flash.external.ExternalInterface;
  import com.greensock.*; 
  import com.greensock.easing.*;
  import com.greensock.plugins.*;
  import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.StageAlign;
  import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.MouseEvent;
  import flash.net.*;
  import flash.display.LoaderInfo;
  import dotmap.*
  import flash.geom.Point;
  import flash.system.Security;
  

	public class main extends MovieClip
	{
		public var statesXML:XML;
		public var paramObj;
		public var projection:Projection;
		public var stagePadding:Number = 10;
		public var viewState:String = "us";
		public var USStates:Array = ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl", "ga", "hi", "id", "il", "in", "ia", "ks", "ky", "la", "me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne", "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok", "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt", "va", "wa", "wv", "wi", "wy"];
	  public var SmallStates:Array = ["me", "nh", "vt", "ct", "ma", "ri", "nj", "de", "md", "dc"];
	  public var restRoute:String = "corporate/map/85/";
	  public var baseURL:String = "http://www.directeddata.com/services/website/";
	  public var curState:String = "";
	  public var animationTime:Number = 2.5;
	  public var lastState;
		
		public function main()
		{
      /*if(ExternalInterface.available){
        ExternalInterface.addCallback("sendTextToFlash", getDataString);
      }*/
		  
		  Security.allowDomain("*.directeddata.com");
		  
		  if (ExternalInterface.available) {
          try {
              recieved_text_txt.text = "Adding callback...\n";
              ExternalInterface.addCallback("sendTextToFlash", getDataString);
          } catch (error:SecurityError) {
              recieved_text_txt.text = "A SecurityError occurred: " + error.message + "\n";
          } catch (error:Error) {
              recieved_text_txt.text = "An Error occurred: " + error.message + "\n";
          }
      } else {
          recieved_text_txt.text = "External interface is not available for this container.";
      }
      trace("recieved text is " + recieved_text_txt);
      
      paramObj = LoaderInfo(this.root.loaderInfo).parameters;
      
      //set the BaseURL first
      if(paramObj.baseURL){
        baseURL = paramObj.baseURL;
      }
      
      //then set the xml path and load initial data
      if(paramObj.xmlpath){
        restRoute = paramObj.xmlpath;
        loadStates(restRoute);
      }else{
        //loadStates("us" + "1" + ".xml");
        loadStates(restRoute);
      }

      //headling_mc.alpha = 0;
      //stage.align = StageAlign.TOP_LEFT;
      //stage.scaleMode = StageScaleMode.NO_SCALE;
      //stage.addEventListener(Event.RESIZE, onResize);
      
      //dispatch the event to make the stage size apropriately
      dispatchEvent(new Event(Event.RESIZE, true));
      
      //create the projection object to handle our lat/long to x y coordinates
      projection = new Projection();
      
      //create the state clicks
      //click_map_mc.nc_mc.addEventListener(MouseEvent.CLICK, stateClick);
      setupStateButtons();
      setupInitialButtons();
      
      geo_map_mc.visible = false;
      zoom_mc.visible = false;
      
      zoom_mc.addEventListener(MouseEvent.CLICK, zoomOut);
      zoom_mc.buttonMode = true;
      zoom_mc.mouseChildren = false;
      
      scaleClickMap();
		}
    
    public function scaleClickMap():void{
      
      var wpercent:Number = click_map_mc.width/stage.stageWidth;
      var hpercent:Number = click_map_mc.height/stage.stageHeight;
      var xoffset:Number = 0;
      var yoffset:Number = 0;
      var scalePercent:Number = 0;
      
      if(hpercent >= wpercent){
        scalePercent = (stage.stageHeight-(stagePadding*2 ))/click_map_mc.height;
        
        //for horizontal centering
        xoffset = ((stage.stageWidth - (click_map_mc.width*scalePercent))/2) - stagePadding;
      }
      
      if(wpercent >= hpercent){
        scalePercent = (stage.stageWidth-(stagePadding*2 + state_initials.width))/click_map_mc.width;
        
        //for vetical centering
        yoffset = ((stage.stageHeight - (click_map_mc.height*scalePercent))/2) - stagePadding;
      }
      
      click_map_mc.scaleX = scalePercent;
      click_map_mc.scaleY = scalePercent;
      
      click_map_mc.x = stagePadding + xoffset;
      click_map_mc.y = stagePadding + yoffset;
      
      state_initials.y = click_map_mc.y;
      state_initials.x = click_map_mc.x + click_map_mc.width;
    }
    
    public function zoomOut(e:Event):void{
      geo_map_mc.visible = false;
      zoom_mc.visible = false;
      click_map_mc.visible = true;
      dot_holder.visible = false;
      state_initials.visible = true;
      
      //remove the dots this second
      removeDotsNow();
      
      viewState = "us"
      //getDataString(restRoute);
      
      //set the state to empty
      ExternalInterface.call("setState", "");
    }
    
    public function loadStates(str:String):void {
      trace("loading states " + str);
      
      var xmlLoader:URLLoader = new URLLoader();
      var xmlData:XML = new XML();
      xmlLoader.addEventListener(Event.COMPLETE, loadStatesXML);
      xmlLoader.load(new URLRequest(baseURL + str));
      viewState = "us";
    }
    
    public function getDataString(str:String):void {
    	recieved_text_txt.text = "Dataset ID: " + str;
    	restRoute = str;
    	
    	if(viewState == "us"){
    	  loadStates(restRoute);
  	  }
  	  if(viewState == "state"){
    	  loadDots(restRoute);
  	  }
    }
    
    public function setupStateButtons():void{
      for(var i:int = 0; i<USStates.length; i++){
        trace("state is " + USStates[i]);
        var stateMC = click_map_mc[USStates[i] + "_mc"];
        stateMC.addEventListener(MouseEvent.CLICK, stateClick);
        stateMC.buttonMode = true;
        stateMC.mouseChildren = false;
      }
      
      for(var i:int = 0; i<USStates.length; i++){
        trace("state is " + USStates[i]);
        var stateMC = geo_map_mc[USStates[i] + "_mc"];
        stateMC.addEventListener(MouseEvent.CLICK, stateClick);
        stateMC.buttonMode = true;
        stateMC.mouseChildren = false;
      }
    }
    
    public function setupInitialButtons():void{
      for(var i:int = 0; i<SmallStates.length; i++){
        var stateMC = state_initials[SmallStates[i] + "_mc"];
        stateMC.addEventListener(MouseEvent.CLICK, stateClick);
      }
    }
    
    public function stateClick(e:Event):void{
      removeDotsNow();
      var stateMC = e.target.name;
      curState = stateMC.split("_")[0];
      geo_map_mc.visible = true;
      click_map_mc.visible = false;
      zoom_mc.visible = true;
      dot_holder.visible = true;
      state_initials.visible = false;
      
      placeState(stateMC);
      
      ExternalInterface.call("setState", curState);
      //ExternalInterface.call("alert", curState);
    }
    
    public function loadDots(xmlName:String):void{
      var xmlLoader:URLLoader = new URLLoader();
      var xmlData:XML = new XML();
      
      trace("loading dots for " + baseURL + xmlName + curState)
      
      xmlLoader.addEventListener(Event.COMPLETE, loadDotsXML);
      xmlLoader.load(new URLRequest(baseURL + xmlName + curState));
      
      viewState = "state";
    }
    
    public function enableGeoClicks(){
      for(var i:int = 0; i<USStates.length; i++){
        var stateMC = geo_map_mc[USStates[i] + "_mc"];
        stateMC.buttonMode = true;
        stateMC.mouseChildren = false;
      }
    }
    
    public function placeState(mc){
      //enable the buttons on all states
      enableGeoClicks();
      
      mc = geo_map_mc[mc];
      
      //remove the button functionality on the selected state
      mc.buttonMode = false;
      mc.enabled = false;
      
      var wpercent:Number = mc.width/stage.stageWidth;
      var hpercent:Number = mc.height/stage.stageHeight;
      var xoffset:Number = 0;
      var yoffset:Number = 0;
      
      var scalePercent = 1;
      
      if(hpercent >= wpercent){
        scalePercent = (stage.stageHeight-(stagePadding*2))/mc.height;
        
        //for horizontal centering
        xoffset = ((stage.stageWidth - (mc.width*scalePercent))/2) - stagePadding;
      }
      
      if(wpercent >= hpercent){
        scalePercent = (stage.stageWidth-(stagePadding*2))/mc.width;
        
        //for vetical centering
        yoffset = ((stage.stageHeight - (mc.height*scalePercent))/2) - stagePadding;
      }
      
      geo_map_mc.scaleX = scalePercent;
      geo_map_mc.scaleY = scalePercent;
      
      geo_map_mc.x = stagePadding + (Math.abs(mc.x)*scalePercent) + xoffset;
      geo_map_mc.y = stagePadding + (Math.abs(mc.y)*scalePercent) + yoffset;
      
      //color the selected state white
      if(lastState){
        TweenMax.to(lastState, 0, {colorTransform:{tintAmount:0}});
      }
      TweenMax.to(mc, 0, {colorTransform:{tint:0xDDDDDD, tintAmount:1}});
      
      //set the last state 
      lastState = mc;
      
      //load the dots
      //loadDots("nc" + restRoute + ".xml");
      loadDots(restRoute);
    }
    
    public function onResize(e:Event):void
    {
      //numbers_mc.x = stage.stageWidth - numbers_mc.width - 12;
      //numbers_mc.y = stage.stageHeight - numbers_mc.height - 10;
    }
    
    public function colorStates():void{

      for(var i:int = 0; i<USStates.length; i++){
        trace("state is " + USStates[i]);
        var stateMC = click_map_mc[USStates[i] + "_mc"];
        
        TweenMax.to(stateMC, .25, {delay:0, colorTransform:{tint:0xFF00FF, tintAmount:0}});
      }
      
      for(var i:int = 0; i<statesXML.children().length(); i++){
        var stateXML = statesXML.children()[i];
        var stateMC = click_map_mc[stateXML.attribute("name").toLowerCase() + "_mc"];
        var stateColor = uint("0x" + stateXML.attribute("color"));
        
        TweenMax.to(stateMC, .75, {delay:0.28, colorTransform:{tint:stateColor, tintAmount:1}});
      }
    }
    
    public function loadDotsXML(e:Event):void
		{	
		  trace("dotxml loaded")
		  
		  //set the slides to the current XML
			var dotsXML = new XML(e.target.data);
			
			//color the states
      removeDots(dotsXML);
		}
    
    public function removeDots(dotsXML):void{
      if(dot_holder.numChildren!=0){
          var k:int = dot_holder.numChildren;
          while( k -- )
          {
              var dotMC = dot_holder.getChildAt( k );
              TweenMax.to(dotMC, .25, {delay:0.001, scaleX:0, scaleY:0, ease:Quad.easeOut, onComplete:removeDot, onCompleteParams:[dotMC]});
          }
          
          //put a delay on the animation call
          TweenMax.delayedCall(.35, placeDots, [dotsXML]);
          
      }else{
        placeDots(dotsXML);
      }
    }
    
    public function removeDotsNow():void{
      trace("removing dots now!")
      if(dot_holder.numChildren!=0){
          var k:int = dot_holder.numChildren;
          while( k -- )
          {
            var dotMC = dot_holder.getChildAt( k );
            dot_holder.removeChild( dotMC );
          }
          
      }
    }
    
    public function removeDot(mc):void{
      dot_holder.removeChild( mc );
    }
    
    public function placeDots(dotsXML):void{
      
      var dotTime = animationTime/dotsXML.children().length();
      
      //then add all the new children
      for(var i:int = 0; i<dotsXML.children().length(); i++){

        var dotXML = dotsXML.children()[i];
        var dotMC = new Dot();
        dot_holder.addChild(dotMC);
        
        var geoPosition:Object = projection.getCoordinates(Number(dotXML.attribute("lat")), -Number(dotXML.attribute("lon")));
        var dotColor = uint("0x" + dotXML.attribute("color"));
        var dotScale = Number(dotXML.attribute("scale"));

        //get the scale of the map
        var point:Point = geo_map_mc.localToGlobal(new Point(geoPosition.x, geoPosition.y));
        
        dotMC.x = point.x;
        dotMC.y = point.y;
        dotMC.scaleX = 0;
        dotMC.scaleY = 0;
        
        TweenMax.to(dotMC.dot_color, 0, {colorTransform:{tint:dotColor, tintAmount:1}});
        TweenMax.to(dotMC, 1, {delay:0.001 + (i*dotTime), scaleX:1+dotScale, scaleY:1+dotScale, ease:Elastic.easeOut});
      }
    }
    
    public function loadStatesXML(e:Event):void
		{	
		  //set the slides to the current XML
			statesXML = new XML(e.target.data);
			
			//color the states
		  colorStates();
			
      //example tween
			//TweenMax.to(curChild, .8, { alpha:1, ease:Quad.easeInOut, onComplete:removePrevious});
		}
	}
}
