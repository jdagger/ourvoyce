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
  
  $('.vote-table.corporate').fixheadertable({ 
      height      : 400,
      width       : 550,
      minColWidth : 100,
      colratio    : [109, 230, 70, 55, 85], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.executive').fixheadertable({ 
      height      : 400,
      width       : 550,
      minColWidth : 100,
      colratio    : [109, 150, 150, 140], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.house-of-representatives').fixheadertable({ 
      height      : 250,
      width       : 550,
      minColWidth : 100,
      colratio    : [109, 120, 120, 90, 110], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.legislative-state').fixheadertable({ 
      height      : 400,
      width       : 550,
      minColWidth : 100,
      colratio    : [190, 190, 169], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.agency').fixheadertable({ 
      height      : 400,
      width       : 550,
      minColWidth : 100,
      colratio    : [109, 340, 100], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.media-show').fixheadertable({ 
      height      : 400,
      width       : 550,
      minColWidth : 100,
      colratio    : [109, 340, 100], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.media-list').fixheadertable({ 
      height      : 400,
      width       : 550,
      minColWidth : 100,
      colratio    : [340, 109, 100], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.myvoyce').fixheadertable({ 
      height      : 400,
      width       : 700,
      minColWidth : 100,
      colratio    : [109, 140, 160, 180, 110], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.home-page').fixheadertable({ 
      height      : 300,
      width       : 330,
      minColWidth : 100,
      colratio    : [150, 70, 110], //totals up to 549 wich is the width of the vote table
      wrapper     : false,
      zebraClass  : 'even',
      zebra       : true
  });
  
}); //end document.ready