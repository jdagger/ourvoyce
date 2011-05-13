// This contains all base javascript (e.g. siFR, swfobject calls, etc)
//
//  base.js
//  
//  Copyright 2010 EfficiencyLab. All rights reserved.
// 

$(document).ready(function() {
  
  /////////////////////////////////////////////////////////////// cufon
  
  // Subway Ticker Font
  //Cufon.replace('.counter p', {hover:true, fontFamily: 'Subway Ticker'});

  // add dividers to top and footer navigation
  $('#header-nav ul li:not(:first)').before('<li>|</li>');
  
  $('.vote-table.corporate').fixheadertable({ 
      height      : 438,
      width       : 550,
      minColWidth : 100,
      colratio    : [109, 230, 70, 55, 85], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.executive').fixheadertable({ 
      height      : 460,
      width       : 550,
      minColWidth : 100,
      colratio    : [109, 150, 150, 140], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.senators').fixheadertable({ 
      height      : 187,
      width       : 558,
      minColWidth : 100,
      colratio    : [109, 120, 209, 110], //totals up to 549 wich is the width of the vote table
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
      height      : 460,
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
      width       : 700,
      minColWidth : 100,
      colratio    : [109, 150, 150, 140], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
  $('.vote-table.home-page').fixheadertable({ 
      height      : 520,
      width       : 550,
      minColWidth : 80,
      colratio    : [230, 150, 80, 89], //totals up to 549 wich is the width of the vote table
      wrapper     : false
  });
  
}); //end document.ready