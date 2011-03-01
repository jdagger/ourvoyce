// This contains all base javascript (e.g. siFR, swfobject calls, etc)

//  base.js
//  
//  Created by Matt Dills on 2010-04-02.
//  Copyright 2010 Scully Group. All rights reserved.
// 

$(document).ready(function() {
  
  /////////////////////////////////////////////////////////////// cufon
  
  // Subway Ticker Font
  Cufon.replace('.counter p', {hover:true, fontFamily: 'Subway Ticker'});

  // add dividers to top and footer navigation
  $('#header-nav ul li:not(:first)').before('<li>|</li>');
  
  $('.vote-table').fixheadertable({ 
      height      : 400,
      width       : 550,
      minColWidth : 100,
      colratio    : [110, 230, 60, 60, 90], //totals up to 550 wich is the width of the vote table
      wrapper     : false
  });
  
}); //end document.ready