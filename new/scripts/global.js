"use strict";

//
// cachedHTML is used to store html content downloaded when switching between tabs
//

window.cachedHTML = { };

//
// On DOM ready, set up variable references, set the default tab hash, then activate the tab
//

$(window).on("ready", function(event) {
  // Keep references to frequencly used elements
  
  window.windowObject     = $(window);
  
  window.headerBackground = $("#header-background");
  window.headerContent    = $("#header-content");
  window.profileImage     = $("#profile-image");
  window.contentLinks     = $("#content-links");
  window.profileName      = $("header #profile-name");
  window.profileNameSmall = $("nav #profile-name-small");
  window.bodyBackground   = $("body");
  window.footerBackground = $("footer");
  
  // If this is the initial load, set the hash
  
  if (!location.hash) {
    location.hash = "#about";
  }

  // Activate the current tabl based on the hash
  
  activateTab(location.href);
  
  // Load and set deferred background images
  
  bodyBackground.css("background-image", "url(images/space.png)");
  footerBackground.css("background-image", "url(images/planet.png)");
  
  // If on phone in landscape, don't change contentLinks position and top styles
  
  if (window.matchMedia) {
    var mobileQuery = window.matchMedia("(max-width: 360px) and (orientation: portrait)");
  
    window.isPhonePortrait = mobileQuery.matches;
  
    mobileQuery.addListener(function(queryListener) {
      window.isPhonePortrait = mobileQuery.matches;
    });
  }
});

//
// On scroll, resize the header background, and set the positions and opacity of header and side link elements
//

$(document).on("scroll", function(event) {
  var scrollTop = $(window).scrollTop();

  // Header background and side links position
  
  if (scrollTop < 140 && window.headerIsFixed) {
    headerContent.css("width", "");
    headerContent.css("position", "");
    headerContent.css("top", "");
    
    if (!isPhonePortrait) {
      contentLinks.css("position", "");
      contentLinks.css("top", "");
    }
    
    window.headerIsFixed = false;
  }

  // Header content position and opacity

  if (!window.headerIsFixed) {
    var height = 140 - scrollTop / (140 / (140 - 50));
    headerBackground.css("height", Math.max(height, 50) + "px");

    profileName.css("opacity", 1 - (scrollTop / (140 - 50 + 20)));      
    profileName.css("top", -scrollTop / (140 / (140 - 50 - 70)) + "px");
    profileImage.css("top", -scrollTop / (140 / (140 - 50 - 0)) + "px");
    profileImage.css("opacity", 1 - (scrollTop / (140 - 50 + 20)));
    
    var startFade = 100;
    if (scrollTop > startFade) {
      profileNameSmall.css("opacity", (scrollTop - startFade) / (140 - startFade));
    } else {
      profileNameSmall.css("opacity", 0);
    }
  }

  // Header background and side links position
  
  if (scrollTop >= 140 && !window.headerIsFixed) {
    headerContent.css("width", headerContent.width() + "px");
    headerContent.css("position", "fixed");
    headerContent.css("top", "-140px");
    
    if (!isPhonePortrait) {
      contentLinks.css("position", "fixed");
      contentLinks.css("top", "-140px");
    }
    
    window.headerIsFixed = true;
  }
});

//
// On haschange, activate the correct tab
//

$(window).on("hashchange", function(event) {
  activateTab(location.href);
});

//
// Activate tab associated with the href hash
//

function activateTab(href) {
  var resourceName = href.substring(href.indexOf("#")).substring(1);

  // Load the page accosiated with the href hash

  if (cachedHTML[resourceName] != null) {
    $("main").html(cachedHTML[resourceName]);
  } else {
    $("main").load("new/content/" + resourceName + ".html", function(data) {
      cachedHTML[resourceName] = data;
    });
  }

  // Deactivate inactive tabs and set active tab
  
  $("#navigation-bar a").each(function(index, item) {
    $(item).removeClass("current");
    
    if (item.href == href) {
      $(item).addClass("current");
    }
  });
  
  // If header if fixed, scroll to top of contnet
  
  if ($(window).scrollTop() > 140) {
    $(window).scrollTop(140);
  }
}

//
// Automatically scroll to test performance
//

function startScrolling() {
  window.timer = setInterval(function() {
    var scrollTop = $(window).scrollTop();
    console.log($(document).height() - windowObject.height());

    window.scrollTo(0, scrollTop + 2);
    
    if (scrollTop >= $(document).height() - windowObject.height()) {
      clearTimeout(timer);
    }
  }, 1000 / 60);
}
