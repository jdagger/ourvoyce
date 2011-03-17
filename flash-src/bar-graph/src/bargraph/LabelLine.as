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
	import flash.display.StageAlign;
  import flash.display.StageScaleMode;


	public class LabelLine extends MovieClip
	{
		
		public function LabelLine(num:String, lineWidth:Number)
		{
		  if(Number(num) > 1000 && Number(num) < 1000000){
		    num = (Number(num)/1000).toFixed(1) + "K"
		  }
		  if(Number(num) >= 1000000){
		    num = (Number(num)/1000000).toFixed(1) + "M"
		  }
		  
		  label_txt.text = num;
		  line_mc.mask = line_mask;
		  line_mc.width = lineWidth;
		  line_mask.mask_middle.width = line_mc.width - (line_mask.mask_left.width*2);
		  line_mask.mask_right.x = line_mask.mask_middle.x + line_mask.mask_middle.width;
		}
	}
}