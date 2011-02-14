/*
 * Author: Nathan Batson
 * Copyright (c) ScullyTown.com 2009
 * Version: 0.0.1
 */

package dotmap
{

	public class Projection
	{
		public var mapScale:Number = 5.7106136;
		
		public function Projection()
		{
		  //constructor
		}
    
    public function getCoordinates(latitude:Number, longitude:Number):Object
    {
      var mapY:Number = latToY(latitude);
      
      //get the coordinates from this projection
      return { x:-(mapScale*longitude), y:-(mapScale*mapY) }
    }
    
    public function yToLatitude(a:Number):Number { 
      return 180/Math.PI * (2 * Math.atan(Math.exp(a*Math.PI/180)) - Math.PI/2); 
    }
    
    public function latToY(a:Number):Number { 
      return 180/Math.PI * Math.log(Math.tan(Math.PI/4+a*(Math.PI/180)/2)); 
    }
	}
}
