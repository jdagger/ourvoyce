/*
 * Author: Nathan Batson
 * Copyright (c) ScullyTown.com 2009
 * Version: 0.0.1
 */

package bargraph
{
  
  import com.greensock.*; 
  import com.greensock.easing.*;
  import com.greensock.plugins.*;
  import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.MouseEvent;
  
	public class Bar extends MovieClip
	{
	  //this offset is so that we can animate the bars and bars of zero height draw correctly
		public var barOffset:Number = 10;
		public var reflection:Boolean = false;
		
		public function Bar(barXML, barWidth:Number, barHeight:Number, reflect:Boolean, availScale:Number)
		{
		  //constructor
		  reflection = reflect;
		  
		  //barwidth and height
		  if(availScale == 0){
		    bar_wrapper.bar_front.height = 0;
		  }else{
		    bar_wrapper.bar_front.height = (barHeight * Number(barXML.attribute("scale"))) + barOffset;
		  }
		  
		  bar_wrapper.bar_front.width = barWidth;
		  
		  //set the size of the mask relative to the bar
		  bar_mask.mask_top.height = bar_wrapper.bar_front.height;
		  bar_mask.mask_top.width = bar_wrapper.bar_front.width + 10;
		  bar_mask.mask_right.width = bar_mask.mask_top.width - bar_mask.mask_corner.width;
		  
		  //top width
		  bar_wrapper.bar_top.middle.width = barWidth - bar_wrapper.bar_top.top_right.width;
		  bar_wrapper.bar_top.top_right.x = barWidth;
		  bar_wrapper.bar_top.y = -bar_wrapper.bar_front.height;
		  
		  //left height
		  bar_wrapper.bar_left.middle.height = bar_wrapper.bar_front.height - bar_wrapper.bar_left.top_corner.height;
		  bar_wrapper.bar_left.top_corner.y = -bar_wrapper.bar_left.middle.height;
		  
		  if(reflection){
		    bar_mask.visible = false;
		  }else{
		    bar_wrapper.mask = bar_mask;
		  }
		  
		  //set the label
		  label_txt.text = barXML.attribute("label");
		  label_txt.x = (barWidth + 7 - label_txt.width)/2;
		  //set the bar color
		  TweenMax.to(bar_wrapper, .5, {colorMatrixFilter:{colorize:uint("0x" + barXML.attribute("color")), amount:1}});
		  
		  trace("bar added")
		}
		
		public function animateIn():void{
		  if(reflection){
		    bar_wrapper.y = bar_wrapper.height - 55;
		    TweenMax.from(bar_wrapper, 1, { y:"-" + String(bar_wrapper.height), ease:Quad.easeOut});
		  }else{
		    TweenMax.from(bar_wrapper, 1, { y:bar_wrapper.height + 50, ease:Quad.easeOut});
	    }
		}
	}
}