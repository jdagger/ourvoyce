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
  import flash.display.LoaderInfo;
	import flash.events.*;
  import flash.net.*;
  import bargraph.*
  

	public class BarGraph extends MovieClip
	{
		public var graphXML:XML;
		public var paramObj;
		public var baseURL:String = "http://www.directeddata.com/services/website/";
		public var restRoute:String = "corporate/age/85/nc";
		public var stagePadding:Number = 25;
		public var barWidth:Number = 6;
		public var barPadding:Number = 10;
		public var barHeight:Number = 120;
		public var numberOfLines:Number = 4;
		public var baseGraphPosition:Number = 55;
		
		public function BarGraph()
		{
		  setupExternalInterface();
      paramObj = LoaderInfo(this.root.loaderInfo).parameters;
      
      if(paramObj.baseURL){
        baseURL = paramObj.baseURL;
      }
      
      if(paramObj.xmlpath){
        restRoute = paramObj.xmlpath;
        loadGraph(restRoute);
      }else{
        loadGraph(restRoute);
      }

      if(paramObj.barwidth){
        barWidth = paramObj.barwidth;
      }
      
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      //set the bargraph position
      graph_holder.y = stage.stageHeight - baseGraphPosition;
      
      //position the label
      graph_holder.xlabel.x = ((stage.stageWidth + (graph_holder.bars_holder.x/2) - graph_holder.xlabel.width)/2);
      graph_holder.ylabel.y = -((stage.stageHeight - baseGraphPosition - graph_holder.ylabel.height)/2);
      //set the bar height for the size of the flash area
      barHeight = graph_holder.y - stagePadding;
      
      graph_holder.reflection_mask.width = stage.stageWidth;
      graph_holder.bars_holder_reflection.mask = graph_holder.reflection_mask;
      
      //set the reflection texture
      graph_holder.reflection_mc.glow_middle.width = stage.stageWidth - (graph_holder.reflection_mc.glow_left.width*2) -( graph_holder.reflection_mc.x*2);
      graph_holder.reflection_mc.glow_right.x = graph_holder.reflection_mc.glow_middle.x + graph_holder.reflection_mc.glow_middle.width;
		}
    
    public function setupExternalInterface():void{
      if (ExternalInterface.available) {
          try {
              recieved_txt.text = "Adding callback...\n";
              ExternalInterface.addCallback("sendTextToFlash", getDataString);
          } catch (error:SecurityError) {
              recieved_txt.text = "A SecurityError occurred: " + error.message + "\n";
          } catch (error:Error) {
              recieved_txt.text = "An Error occurred: " + error.message + "\n";
          }
      } else {
          recieved_txt.text = "External interface is not available for this container.";
      }
    }
    
    public function loadGraph(str:String):void {
      trace("loading graph " + str);
      
      var xmlLoader:URLLoader = new URLLoader();
      var xmlData:XML = new XML();
      xmlLoader.addEventListener(Event.COMPLETE, graphLoaded);
      xmlLoader.load(new URLRequest(baseURL + str));
    }
    
    public function getDataString(str:String):void {
    	recieved_txt.text = "Loading Graph: " + str;
    	restRoute = str;
      loadGraph(restRoute);
    }
    
    public function graphLoaded(e:Event):void
		{
		  trace("graph loaded");
		  
		  //set the slides to the current XML
			graphXML = new XML(e.target.data);
      
      if(!paramObj.barwidth){
		    //barWidth = (stage.stageWidth - graph_holder.bars_holder.width)/graphXML.children().length();
		  }
      
      //draw the graph
      removeBars(graphXML);
		}
		
		public function removeBars(graphXML):void{
      if(graph_holder.bars_holder.numChildren!=0){
          var k:int = graph_holder.bars_holder.numChildren;
          var l:int = graph_holder.bars_holder_reflection.numChildren;
          
          while( k -- )
          {
              var barMC = graph_holder.bars_holder.getChildAt( k );
              TweenMax.to(barMC, .25, {delay:0.001, scaleY:0, ease:Quad.easeOut, onComplete:removeBar, onCompleteParams:[barMC, graph_holder.bars_holder]});
          }
          while( l -- )
          {
              var barMC = graph_holder.bars_holder_reflection.getChildAt( l );
              TweenMax.to(barMC, .25, {delay:0.001, scaleY:0, ease:Quad.easeOut, onComplete:removeBar, onCompleteParams:[barMC, graph_holder.bars_holder_reflection]});
          }
          
          
          
          //put a delay on the animation call
          TweenMax.delayedCall(.35, drawGraph, [graphXML]);
      }else{
        drawGraph(graphXML);
      }
    }
		
		public function removeBar(mc, parent):void{
		  parent.removeChild(mc);
		}
		
		public function drawGraph(graphXML):void{
		  
		  //recalculate the bar padding
		  var spaceAvailable = (stage.stageWidth - graph_holder.bars_holder.x - stagePadding) - (graphXML.children().length() * barWidth);
		  barPadding = spaceAvailable/(graphXML.children().length()+1);
		  
		  //set the labels
		  graph_holder.xlabel.text = graphXML.attribute("xlabel");
		  graph_holder.ylabel.text = graphXML.attribute("ylabel");
		  
		  var availableScale:Number = Number(graphXML.attribute("scaletop")) - Number(graphXML.attribute("scalebottom"));
		  var scaleBottom:Number = Number(graphXML.attribute("scalebottom"));
		  //create the gridlines
		  
		  //create the bars
		  drawBars(graph_holder.bars_holder, graphXML, availableScale);
		  drawBars(graph_holder.bars_holder_reflection, graphXML, availableScale, true);
		  
		  var k:int = graph_holder.grid_holder.numChildren;
      
      while( k -- )
      {
          var line = graph_holder.grid_holder.getChildAt( k );
          graph_holder.grid_holder.removeChild(line);
      }
		  
		  for(var j:int = 0; j<numberOfLines+1; j++){
		    var lineY = j * (barHeight/numberOfLines);
		    var labelNumber = j * (availableScale/numberOfLines);
        
        if(labelNumber%1 != 0){
          labelNumber = "";
        }else{
          labelNumber = scaleBottom + labelNumber;
        }
        
		    var line = new LabelLine(String(labelNumber), stage.stageWidth - graph_holder.bars_holder.x - stagePadding);
		    graph_holder.grid_holder.addChild(line);
		    line.y = -lineY
		  }
		}
		
		public function drawBars(holder, graphXML, availableScale:Number, reflection:Boolean = false):void{
		  var bars:Array = new Array();
		  
		  for(var i:int=0; i<graphXML.children().length(); i++){
		    var barXML = graphXML.children()[i];
		    var bar = new Bar(barXML, barWidth, barHeight, reflection, availableScale);
		    holder.addChild(bar);
		    
		    //add to the bars array
		    bars.push(bar);
		    
		    //place the bar based on the set bar width
		    bar.x = barPadding + (i * (barWidth + barPadding));
		    bar.animateIn();
		  }
		  
		  for(var i:int=0; i<bars.length; i++){
		    var bar = bars[i]
		    
		    //change the holder
		    holder.setChildIndex(bar, (bars.length - 1) - i);
		  }
		}
		
	}
}
